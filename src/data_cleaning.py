import pandas as pd

# Load datasets
orders = pd.read_csv("data/raw/List of Orders.csv")
details = pd.read_csv("data/raw/Order Details.csv")
targets = pd.read_csv("data/raw/Sales target.csv")


# -----------------------------
# 1. Clean Orders
# -----------------------------

print("Original orders shape:", orders.shape)

# Remove completely empty rows
orders = orders.dropna(how="all")

# Convert Order Date to proper date format
orders["Order Date"] = pd.to_datetime(
    orders["Order Date"],
    dayfirst=True
)

# Remove duplicate orders
orders = orders.drop_duplicates(subset=["Order ID"])

print("Cleaned orders shape:", orders.shape)


# -----------------------------
# 2. Check Order Details
# -----------------------------

print("\nOrder details shape:", details.shape)
print("Missing values:")
print(details.isnull().sum())


# -----------------------------
# 3. Check Sales Targets
# -----------------------------

print("\nSales targets shape:", targets.shape)
print("Missing values:")
print(targets.isnull().sum())


# -----------------------------
# 4. Display cleaned orders
# -----------------------------

print("\nCleaned orders:")
print(orders.head())

print("\nMissing values after cleaning:")
print(orders.isnull().sum())

# -----------------------------
# 5. Merge Orders and Details
# -----------------------------

merged_data = pd.merge(
    orders,
    details,
    on="Order ID",
    how="inner"
)

print("\nMerged dataset shape:", merged_data.shape)

print("\nMerged dataset:")
print(merged_data.head())

print("\nMissing values in merged dataset:")
print(merged_data.isnull().sum())

# -----------------------------
# 6. Validate the merge
# -----------------------------

print("\nUnique Order IDs in orders:", orders["Order ID"].nunique())
print("Unique Order IDs in details:", details["Order ID"].nunique())
print("Unique Order IDs after merge:", merged_data["Order ID"].nunique())

print("\nRows per Order ID:")
print(merged_data["Order ID"].value_counts().head())

print("\nDate range:")
print(merged_data["Order Date"].min(), "to", merged_data["Order Date"].max())

# -----------------------------
# 7. Save cleaned dataset
# -----------------------------

merged_data.to_csv(
    "data/cleaned_sales.csv",
    index=False
)

print("\nCleaned dataset saved successfully!")
print("File: data/cleaned_sales.csv")