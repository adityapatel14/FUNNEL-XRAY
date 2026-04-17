import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# -------------------------
# CONFIG
# -------------------------
NUM_USERS = 1500
MAX_SESSIONS_PER_USER = 6
START_DATE = datetime(2024, 1, 1)

NAMES = ["Aditya", "Rahul", "Priya", "Sneha", "Amit", "Neha", "Karan", "Isha"]
GENDERS = ["Male", "Female", "M", "F", "male", "female", None, "Unknown"]
COUNTRIES = ["India", "india", "USA", "U.S.A", "UK", "Germany", None]
DEVICES = ["mobile", "web", "Mobile", "WEB", None]
TRAFFIC_SOURCES = ["organic", "ads", "referral", None]

PRODUCTS = [
    {"product_id": "P1", "price": 500},
    {"product_id": "P2", "price": 1200},
    {"product_id": "P3", "price": 300},
]

EVENT_FLOW = ["signup", "view_product", "add_to_cart", "purchase"]

data = []
users = []

# -------------------------
# USER DATA (DIRTY)
# -------------------------
for user_id in range(1, NUM_USERS + 1):
    
    name = random.choice(NAMES)
    
    # Introduce messy names
    if random.random() < 0.3:
        name = " " + name.lower() + " "
    
    gender = random.choice(GENDERS)
    country = random.choice(COUNTRIES)
    
    signup_date = START_DATE + timedelta(days=random.randint(0, 60))
    
    # Missing signup_date
    if random.random() < 0.05:
        signup_date = None
    
    users.append({
        "user_id": user_id if random.random() > 0.02 else user_id - 1,  # duplicate IDs
        "name": name,
        "gender": gender,
        "country": country,
        "signup_date": signup_date
    })

users_df = pd.DataFrame(users)

# -------------------------
# EVENT DATA (DIRTY)
# -------------------------
def generate_session(user):
    session_id = f"sess_{random.randint(100000,999999)}"
    
    base_date = user["signup_date"] if user["signup_date"] else START_DATE
    session_start = base_date + timedelta(days=random.randint(0, 30))
    
    current_time = session_start
    
    for event in EVENT_FLOW:
        
        product = random.choice(PRODUCTS)
        quantity = random.randint(1, 3)
        
        price = product["price"]
        
        # Inject bad price
        if random.random() < 0.05:
            price = -price
        
        # Missing product
        product_id = product["product_id"] if random.random() > 0.1 else None
        
        revenue = price * quantity if event == "purchase" else 0
        
        row = {
            "user_id": user["user_id"],
            "session_id": session_id,
            "event": event,
            "timestamp": current_time,
            "device": random.choice(DEVICES),
            "traffic_source": random.choice(TRAFFIC_SOURCES),
            "country": user["country"],
            "product_id": product_id,
            "price": price if random.random() > 0.05 else None,
            "quantity": quantity,
            "revenue": revenue
        }
        
        data.append(row)
        
        # Duplicate rows
        if random.random() < 0.03:
            data.append(row)
        
        # Future timestamp issue
        if random.random() < 0.02:
            row["timestamp"] = datetime(2035, 1, 1)
        
        # Drop-off
        if random.random() < 0.3:
            data.append({
                "user_id": user["user_id"],
                "session_id": session_id,
                "event": "drop_off",
                "timestamp": current_time + timedelta(minutes=5),
                "device": random.choice(DEVICES),
                "traffic_source": random.choice(TRAFFIC_SOURCES),
                "country": user["country"],
                "product_id": None,
                "price": None,
                "quantity": None,
                "revenue": 0
            })
            break
        
        current_time += timedelta(minutes=random.randint(2, 15))


# Generate events
for _, user in users_df.iterrows():
    sessions = random.randint(1, MAX_SESSIONS_PER_USER)
    for _ in range(sessions):
        generate_session(user)

events_df = pd.DataFrame(data)

# Shuffle
events_df = events_df.sample(frac=1).reset_index(drop=True)

# Save
users_df.to_csv("users_dirty.csv", index=False)
events_df.to_csv("events_dirty.csv", index=False)

print("Users:", users_df.shape)
print("Events:", events_df.shape)