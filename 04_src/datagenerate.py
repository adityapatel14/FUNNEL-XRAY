import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

np.random.seed(42)

# -----------------------------
# USERS TABLE (with messiness)
# -----------------------------
num_users = 800

first_names = ["Amit","Rahul","Priya","Sneha","Arjun","Neha","Karan","Isha"]
last_names = ["Sharma","Patel","Mehta","Rao","Verma","Singh","Kapoor","Nair"]

users = pd.DataFrame({
    "user_id": [f"U{i}" for i in range(1, num_users+1)],
    
    # ✅ ADD: name
    "name": [
        random.choice(first_names) + " " + random.choice(last_names)
        for _ in range(num_users)
    ],
    
    # ✅ ADD: email
    "email": [f"user{i}@gmail.com" for i in range(1, num_users+1)],
    
    "signup_date": [
        datetime(2023,1,1) + timedelta(days=random.randint(0,365))
        for _ in range(num_users)
    ],
    
    # ❌ messy country
    "country": np.random.choice(
        ["India", "india", "US", "UK", "Germany", None],
        num_users
    ),
    
    # ❌ messy device
    "device": np.random.choice(
        ["iOS", "Android", "Web", "web", None],
        num_users
    )
})

# ❌ introduce duplicates
users = pd.concat([users, users.sample(20)])

# -----------------------------
# PRODUCTS TABLE (slightly messy)
# -----------------------------
products = pd.DataFrame({
    "product_id": [f"P{i}" for i in range(1, 11)],
    "product_name": [
        "Free Plan","Basic Plan","Pro Plan","Enterprise Plan",
        "Analytics Dashboard","Email Automation","CRM Tool",
        "AI Insights","Mobile App","API Access"
    ],
    "category": [
        "Subscription","subscription","Subscription","Subscription",
        "Feature","Feature","feature","Feature",
        "Platform","Platform"
    ],
    "price": [
        0,10,25,60,15,12,20,30,0,18
    ]
})

# -----------------------------
# EVENTS TABLE (main messy data)
# -----------------------------
num_events = 10000

event_types = ["view","click","add_to_cart","purchase","login"]

events = pd.DataFrame({
    "event_id": [f"E{i}" for i in range(1, num_events+1)],
    "user_id": np.random.choice(users["user_id"], num_events),
    "event_type": np.random.choice(event_types, num_events),
    "product_id": np.random.choice(products["product_id"].tolist() + ["P999"], num_events),  # invalid ID
    "event_time": [datetime(2023,1,1) + timedelta(days=random.randint(0,365)) for _ in range(num_events)]
})

# introduce missing values
events.loc[events.sample(200).index, "product_id"] = None

# introduce duplicates
events = pd.concat([events, events.sample(100)])

# -----------------------------
# TRANSACTIONS TABLE
# -----------------------------
transactions = events[events["event_type"] == "purchase"].copy()

transactions["transaction_id"] = [f"T{i}" for i in range(1, len(transactions)+1)]

# merge product details
transactions = transactions.merge(products, on="product_id", how="left")

# amount from price
transactions["amount"] = transactions["price"]

# ✅ ADD: payment method (realistic)
transactions["payment_method"] = np.random.choice(
    ["UPI","Credit Card","Debit Card","Net Banking", None],
    len(transactions)
)

# ✅ ADD: transaction status
transactions["status"] = np.random.choice(
    ["success","failed","pending"],
    len(transactions),
    p=[0.85, 0.10, 0.05]
)

# ❌ introduce wrong values
transactions.loc[transactions.sample(50).index, "amount"] = -100  # invalid revenue

# ❌ missing payment method
transactions.loc[transactions.sample(30).index, "payment_method"] = None

# ❌ inconsistent status
transactions.loc[transactions.sample(20).index, "status"] = "Success"  # case issue

# final columns
transactions = transactions[[
    "transaction_id",
    "user_id",
    "product_id",
    "amount",
    "payment_method",
    "status",
    "event_time"
]]

# -----------------------------
# SAVE FILES
# -----------------------------
# -----------------------------
# SAVE FILES (MESSY DATASET)
# -----------------------------
users.to_csv("messy_users.csv", index=False)
products.to_csv("messy_products.csv", index=False)
events.to_csv("messy_events.csv", index=False)
transactions.to_csv("messy_transactions.csv", index=False)

print("✅ Messy Dataset Generated Successfully!")