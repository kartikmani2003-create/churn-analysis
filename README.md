Customer Churn Analysis

A behavioral analysis of customer churn drivers, examining engagement patterns, payment failures, support ticket volume, and usage trends to identify predictive signals and recommend intervention strategies.

## Overview

This project investigates **why customers churn** by analyzing four independent behavioral dimensions:

1. **Login frequency & recency**
2. **Payment failures**
3. **Support ticket volume**
4. **Usage trends**

The goal was to move beyond a single "churn score" and identify *specific, actionable thresholds* where intervention can meaningfully reduce churn.

## Key Findings

### 1. Engagement & Recency
- **87%** of users hadn't logged in for 7+ days â€” a strong signal of disengagement.
- Churned users are inactive for **6 more days on average** and use the product **12% less weekly** than retained users.
- Users segment into three recency-based health tiers:
  - 52% Healthy
  - 31% At-risk
  - 17% Almost-churned
- Average recency gap: **32 days (churned)** vs **26.1 days (retained)**.

### 2. Payment Failures
- Churn jumps from ~40% to **64â€“67%** after 2+ payment failures.
- Users with any payment failure churn at **60.6%** â€” ~21 points higher than users without.
- Churned users average **2.8 failures** vs **2.07** for retained users.
- Failure-driven churn is consistent (~68.5%) **across all price tiers**, suggesting a systemic payment/gateway issue rather than an affordability problem.

### 3. Support Tickets
- Churn holds near 50â€“57% for 1â€“3 tickets, then spikes to **68%** at 5+ tickets.
- Churned users average **4.22 tickets** vs **3.44** for active users.
- Ticket volume per plan is consistent (~3.9), indicating a **product-wide** issue, not plan-specific.
- Support tickets and payment failures are **statistically independent** (Pearson correlation â‰ˆ **-0.007**) â€” two separate churn drivers.

### 4. Usage Trends
- Users with <5 hrs/week usage churn at **76.29%** vs the overall average of **57.3%**.
- **5 hrs/week is a critical engagement threshold** â€” churn drops sharply above it.
- Beyond 10 hrs/week, additional usage doesn't meaningfully reduce churn (plateaus at ~53â€“54%).
- **Tenure is not a strong churn driver** â€” churn is flat across new (56.6%), old (57.1%), and loyal (58.3%) users, disproving the "new users churn more" hypothesis.

## Recommended Actions

| Trigger | Action |
|---|---|
| No login for 20+ days, or weekly usage drops below 5 hrs | Fire retention alert / re-engagement flow |
| 4th support ticket | Auto-escalate to senior agent |
| 5th support ticket | Offer retention discount |
| 2+ payment failures | Fix/retry payment gateway flow before compounding |
| Payment failures & support tickets | Treat as **separate** retention workstreams (proven independent) |
| Loyal/long-tenure users | Extend re-engagement campaigns beyond just new-user onboarding |

## Methodology

- Segmented users by recency, plan tier, ticket count, and weekly usage buckets.
- Compared churned vs. retained cohorts across each dimension using average/percentage breakdowns.
- Ran Pearson correlation between support tickets and payment failures to test for a shared root cause.
- Validated findings against a tenure-based null hypothesis (new vs. old vs. loyal users).

## Tools Used

- *(Add here: e.g. SQL / Python / Pandas / Excel  whichever tool you used to pull and analyze the data)*

## Author

*(A Kartik mani)*
