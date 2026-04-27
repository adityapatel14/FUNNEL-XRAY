# 📊 SaaS Funnel Drop-off Analysis — Key Insights
> Project: FUNNEL-XRAY | Dataset: Synthetic | Year: 2023 | Tool: Python (Pandas), SQL

---

## 1. 👥 User Overview

- **Total Users:** 800
- **Total Rows in Merged Dataset:** 9,763 (due to fan-out from joining all 4 tables)
- **Orphaned Users:** 20 users exist in `cleaned_events` but have no record in `cleaned_users` — flagged as a data quality issue and excluded from funnel analysis

**Users by Country:**
| Country | Users |
|---|---|
| India | 270 (33.8%) |
| UK | 149 (18.6%) |
| Germany | 139 (17.4%) |
| US | 121 (15.1%) |
| Unknown | 121 (15.1%) |

**Users by Device:**
| Device | Users |
|---|---|
| Web | 300 (37.5%) |
| Unknown | 168 (21.0%) |
| Android | 166 (20.8%) |
| iOS | 166 (20.8%) |

> ⚠️ 21% of users have unknown device — suggests device tracking was not fully implemented at data collection time.

---

## 2. 🔻 Funnel Analysis (Login → Purchase)

| Stage | Users | Drop-off | Drop-off % |
|---|---|---|---|
| Login | 800 | — | — |
| View | 601 | 199 | ↓ 24.9% |
| Click | 421 | 180 | ↓ 29.9% |
| Add to Cart | 253 | 168 | ↓ 39.9% |
| Purchase | 139 | 114 | ↓ 45.1% |

- **Overall Conversion Rate (Login → Purchase):** 17.4%
- **Largest Drop-off:** Add to Cart → Purchase **(45.1%)** — suggesting friction at checkout, pricing hesitation, or payment failure
- **Second Largest Drop-off:** Click → Add to Cart **(39.9%)** — users browsing but not committing to cart

> 💡 Nearly half of users who showed clear purchase intent (added to cart) still did not complete the purchase — this is the highest priority area for optimization.

---

## 3. 📅 Event Analysis

**Event Type Distribution (3,886 total events):**
| Event Type | Count | % of Total |
|---|---|---|
| Login | 1,628 | 41.9% |
| View | 1,223 | 31.5% |
| Click | 643 | 16.5% |
| Add to Cart | 253 | 6.5% |
| Purchase | 139 | 3.6% |

**Top 5 Most Interacted Products:**
| Product | Interactions |
|---|---|
| Basic Plan | 384 |
| AI Insights | 379 |
| API Access | 375 |
| CRM Tool | 359 |
| Mobile App | 358 |

> 💡 Login events dominate at 41.9% — users are active but drop significantly at deeper engagement stages. Basic Plan leads product interactions, consistent with it being the top revenue driver.

---

## 4. 💰 Transaction & Revenue Analysis

- **Total Transactions:** 1,931
- **Total Revenue (Successful):** $28,132
- **Total Lost Revenue (Failed):** $4,657
- **Revenue Recovery Rate:** 85.8% collected, 14.2% lost

**Transaction Status Breakdown:**
| Status | Count | % |
|---|---|---|
| Success | 1,631 | 84.5% |
| Failed | 210 | 10.9% |
| Pending | 90 | 4.7% |

**User Payment Segmentation:**
| Segment | Users |
|---|---|
| Paid at least once (amount > 0) | 659 (82.4%) |
| Zero amount transactions only | 373 (46.6%) |
| Never transacted | 74 (9.3%) |

> ⚠️ Note: Segments overlap — some users have both paid and zero-amount transactions.

**Revenue by Country:**
| Country | Revenue |
|---|---|
| India | $9,667 (34.4%) |
| UK | $5,456 (19.4%) |
| Unknown | $4,565 (16.2%) |
| Germany | $4,269 (15.2%) |
| US | $4,175 (14.8%) |

> 💡 India drives 34% of total revenue — the largest single market. Combined with being the largest user base (270 users), India is clearly the primary target market.

**Revenue by Payment Method:**
| Method | Revenue |
|---|---|
| No Payment (Free/Untraced) | $6,269 |
| UPI | $6,083 |
| Net Banking | $5,362 |
| Debit Card | $5,315 |
| Credit Card | $5,103 |

> 💡 UPI is the top traceable payment method at $6,083 — consistent with India being the dominant market since UPI is India's primary digital payment system.

---

## 5. ❌ Payment Failure Analysis

- **Total Failed Transactions:** 210 (10.9% of all transactions)
- **Revenue Lost to Failures:** $4,657

**Failed Transactions by Payment Method:**
| Method | Failed Count |
|---|---|
| No Payment / Unknown | 52 |
| UPI | 33 |
| Net Banking | 32 |
| Credit Card | 29 |
| Debit Card | 29 |

**Failed Transactions by Country:**
| Country | Failed Count |
|---|---|
| India | 57 |
| Germany | 33 |
| UK | 30 |
| US | 30 |
| Unknown | 25 |

> 💡 India has the most failures (57) but also the most users and transactions — proportionally this is expected. Unknown payment method accounts for 52 failures, suggesting a payment gateway logging issue that needs investigation.

**Unknown Payment Breakdown:**
- 269 transactions — payment succeeded but method was untraced
- 52 transactions — payment failed with undetectable method
- 93 transactions — zero amount (free tier activations)

> ⚠️ The unknown payment gateway issue affects both successful and failed transactions — suggesting a systemic logging failure rather than isolated incidents.

---

## 6. 📦 Product & Category Analysis

**Revenue by Subscription Plan:**
| Plan | Revenue |
|---|---|
| Basic Plan ($10) | $2,837 |
| Email Automation ($12) | $2,699 |
| CRM Tool ($20) | $2,648 |
| Mobile App (Free/$0) | $2,631 |
| Enterprise Plan ($60) | $2,575 |
| Pro Plan ($25) | $2,496 |
| Analytics Dashboard ($15) | $2,128 |

**Revenue by Category:**
| Category | Revenue |
|---|---|
| Subscription | $10,522 (37.4%) |
| Feature | $9,996 (35.5%) |
| Platform | $5,148 (18.3%) |
| Unknown | $2,466 (8.8%) |

> 💡 Basic Plan is the top revenue driver despite being the cheapest paid plan ($10) — its high adoption volume outweighs the higher-priced Pro ($25) and Enterprise ($60) plans. This suggests users prefer entry-level pricing, pointing to a potential upsell opportunity.

> 💡 Subscription and Feature categories are nearly equal in revenue ($10,522 vs $9,996) — users are spending almost as much on individual features as on subscription plans, indicating strong feature demand independent of plan tier.

---

## 7. 🚩 Data Quality Flags

| Issue | Detail |
|---|---|
| Orphaned users | 20 users in events table with no user record |
| Unknown device | 168 users (21%) have untracked device |
| Unknown country | 121 users (15.1%) have unidentified location |
| Unknown payment | 414 transactions with undetectable payment method |
| P0 product | "Unknown" product (P0) appears in events — placeholder for untracked interactions |

---

## 8. 🔑 Summary of Key Findings

1. **45.1% of users drop off at the final checkout step** (Add to Cart → Purchase) — the most critical funnel bottleneck
2. **Overall funnel conversion is 17.4%** — only 139 out of 800 users completed a purchase event
3. **India is the dominant market** — 34% of users and 34.4% of revenue
4. **UPI is the top traceable payment method** — $6,083 in revenue, consistent with India dominance
5. **$4,657 in revenue was lost to failed transactions** — 10.9% failure rate
6. **Basic Plan drives the most revenue** despite being the cheapest paid tier — high volume compensates for low price
7. **Payment gateway logging issue** — 414 transactions show unknown payment method, 52 of which failed
8. **74 users never interacted with any transaction** — earliest possible drop-off point in the funnel
