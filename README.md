# 🔻 Funnel Drop-Off Analysis

> Analyzing user behavior across a SaaS product funnel — from login to purchase — to identify where and why users disengage.

---

## 📌 Project Overview

This project performs an end-to-end **funnel drop-off analysis** for a SaaS platform. The goal is to map the user journey across five key engagement stages — **Login → View → Click → Add to Cart → Purchase** — and quantify conversion rates, drop-off points, and behavioral patterns that affect revenue.

By combining event tracking data, user demographics, product details, and transaction records, this analysis helps product and growth teams answer questions like:
- Where are users exiting the funnel?
- Which user segments convert best?
- Which products drive the most revenue?
- What payment methods and failure rates affect purchases?

---

## 📁 Dataset Structure

```
funnel-drop-off-analysis/
├── data/                     # Raw and cleaned datasets (events, users, products, transactions)
├── sql/                      # SQL scripts used for funnel and drop-off analysis
├── src/                      # Python scripts for data generating , cleaning and preprocessing
└── README.md                 # Project documentation
```

---

## 🗂️ Data Dictionary

### `cleaned_events.csv` — 3,973 rows × 5 columns

Tracks every user interaction with the platform throughout 2023.

| Column | Type | Description |
|---|---|---|
| `event_id` | string | Unique identifier for each event (e.g., `E1`) |
| `user_id` | string | Reference to the user who triggered the event |
| `event_type` | string | Type of event: `login`, `view`, `click`, `add_to_cart`, `purchase` |
| `product_id` | string | Product associated with the event |
| `event_time` | date | Date the event occurred (YYYY-MM-DD) |

**Event distribution:**

| Event Type | Count | % of Total |
|---|---|---|
| login | 1,669 | 42.0% |
| view | 1,248 | 31.4% |
| click | 657 | 16.5% |
| add_to_cart | 258 | 6.5% |
| purchase | 141 | 3.5% |

---

### `cleaned_users.csv` — 800 rows × 7 columns

User profile data collected at signup.

| Column | Type | Description |
|---|---|---|
| `user_id` | string | Unique user identifier (e.g., `U1`) |
| `name` | string | Full name of the user |
| `email` | string | Email address |
| `signup_date` | date | Date the user created their account |
| `country` | string | User's country: `india`, `uk`, `germany`, `us`, `unknown` |
| `device` | string | Device used at signup |
| `user_id_num` | integer | Numeric version of user_id for joins/ordering |

**User distribution by country:**

| Country | Users |
|---|---|
| India | 270 |
| UK | 149 |
| Germany | 139 |
| US | 121 |
| Unknown | 121 |

---

### `cleaned_products.csv` — 11 rows × 4 columns

Complete product catalog across three categories.

| Column | Type | Description |
|---|---|---|
| `product_id` | string | Unique product identifier (e.g., `P1`) |
| `product_name` | string | Display name of the product |
| `category` | string | Product category: `subscription`, `feature`, `platform` |
| `price` | integer | Price in USD (0 = free) |

**Products by category:**

| Category | Products | Price Range |
|---|---|---|
| Subscription | Free Plan, Basic ($10), Pro ($25), Enterprise ($60) | $0 – $60 |
| Feature | Analytics Dashboard ($15), Email Automation ($12), CRM Tool ($20), AI Insights ($30) | $12 – $30 |
| Platform | Mobile App (Free), API Access ($18) | $0 – $18 |

---

### `cleaned_transactions.csv` — 1,931 rows × 9 columns

Records of all payment transactions linked to user events.

| Column | Type | Description |
|---|---|---|
| `transaction_id` | string | Unique transaction identifier (e.g., `T1`) |
| `transaction_id_num` | integer | Numeric version for ordering |
| `user_id` | string | User who initiated the transaction |
| `user_id_num` | integer | Numeric user reference |
| `product_id` | string | Product purchased |
| `amount` | integer | Transaction amount in USD |
| `payment_method` | string | Payment method used |
| `status` | string | Transaction outcome: `success`, `pending`, `failed` |
| `event_time` | date | Date of transaction |

**Transaction status breakdown:**

| Status | Count | % |
|---|---|---|
| Success | 1,631 | 84.5% |
| Failed | 210 | 10.9% |
| Pending | 90 | 4.7% |

**Payment methods used:**

| Method | Count |
|---|---|
| No Payment (Free) | 430 |
| UPI | 413 |
| Net Banking | 374 |
| Debit Card | 359 |
| Credit Card | 355 |

**Transaction amount stats:** Mean: $17.90 | Median: $15.00 | Max: $60.00

---

## 🔍 Key Analysis Questions

This dataset is structured to support the following analytical directions:

1. **Funnel Conversion Rate** — What % of users who log in ultimately make a purchase?
2. **Stage-by-Stage Drop-Off** — Between which two funnel stages is the biggest user loss?
3. **Product-Level Funnel** — Which products have the highest view-to-purchase conversion?
4. **Geographic Segmentation** — Do users from certain countries convert better?
5. **Payment Failure Impact** — How do failed/pending transactions affect revenue?
6. **Time-Based Trends** — Are there seasonal peaks or dips in activity? (Full year: Jan–Dec 2023)
7. **Cohort Analysis** — Do users who signed up earlier have better lifetime conversion?

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| Python (pandas, matplotlib, seaborn) | Data wrangling and visualization |
| SQL | Funnel queries and cohort joins |
| Power BI / Tableau | Dashboard for funnel visualization |
| Jupyter Notebook | Exploratory Data Analysis (EDA) |

---

## ⚙️ Setup & Usage

```bash
# Clone the repository
git clone https://github.com/adityapatel14/FUNNEL-XRAY.git
cd FUNNEL-XRAY

# Install dependencies
pip install pandas matplotlib seaborn jupyter

# Launch notebook
jupyter notebook
```


---

## 📊 Funnel Visualization (Actual Data)

```
Funnel Stage    Users    Prev Stage   Drop-off    Drop-off %
─────────────────────────────────────────────────────────────
🟦 Login          820         —           —            —
🟦 View           615        820         205        ↓ 25.00%
🟦 Click          430        615         185        ↓ 30.08%
🟦 Add to Cart    258        430         172        ↓ 40.00%
🟦 Purchase       141        258         117        ↓ 45.35%
─────────────────────────────────────────────────────────────
Overall conversion (Login → Purchase): 141 / 820 = 17.2%
Largest single drop-off:  Add to Cart → Purchase  (-45.35%)
```

> The steepest drop occurs at the **final checkout step** (Add to Cart → Purchase), suggesting friction at payment or pricing — making it the highest-priority area for optimization.

---

## 📌 Notes & Assumptions

- All dates fall within **calendar year 2023** (Jan 1 – Dec 31).
- The `P0` product (`Unknown`, price $0) is a placeholder for untracked or free interactions and should be filtered out in conversion analysis.
- Users with `country = unknown` may be excluded from geographic segmentation depending on analysis scope.
- `device = unknown` for most users suggests device tracking was not fully implemented at the time of data collection.
- The `no payment` method corresponds to free-tier product access and should not be counted as a failed transaction.

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

---

## 📄 License

This project is for analytical and educational purposes. Data has been anonymized.
