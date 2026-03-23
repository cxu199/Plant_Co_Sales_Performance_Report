"""data_cleaning.py

Purpose:
- Load the raw Plant Co Excel workbook
- Clean and standardize column names
- Filter invalid dimension rows
- Join fact + dimensions for QA and export
- Create a clean flat file for downstream analysis

Usage:
    python data_cleaning.py
"""

from pathlib import Path
import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_FILE = PROJECT_ROOT / "data" / "raw" / "Plant_Co_Sales_Dataset.xlsx"
OUTPUT_DIR = PROJECT_ROOT / "data" / "cleaned"


def clean_columns(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df.columns = (
        df.columns.str.strip()
        .str.lower()
        .str.replace(" ", "_", regex=False)
        .str.replace(r"[^a-z0-9_]+", "", regex=True)
    )
    return df


def load_data() -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    fact = pd.read_excel(RAW_FILE, sheet_name="Plant_FACT")
    accounts = pd.read_excel(RAW_FILE, sheet_name="Accounts")
    products = pd.read_excel(RAW_FILE, sheet_name="Plant_Hierarchy")

    return clean_columns(fact), clean_columns(accounts), clean_columns(products)


def transform(
    fact: pd.DataFrame, accounts: pd.DataFrame, products: pd.DataFrame
) -> pd.DataFrame:
    fact = fact.copy()
    accounts = accounts.copy()
    products = products.copy()

    # Enforce types
    fact["date_time"] = pd.to_datetime(fact["date_time"])
    numeric_cols = ["sales_usd", "quantity", "price_usd", "cogs_usd"]
    for col in numeric_cols:
        fact[col] = pd.to_numeric(fact[col], errors="coerce")

    # Remove bad dimension rows not usable for joins
    accounts = accounts[accounts["account_id"].notna()].copy()

    # Deduplicate dimensions
    accounts = accounts.drop_duplicates(subset=["account_id"])
    products = products.drop_duplicates(subset=["product_name_id"])

    # Join for a clean analytics flat file
    merged = (
        fact.merge(accounts, on="account_id", how="left", validate="many_to_one")
            .merge(
                products,
                left_on="product_id",
                right_on="product_name_id",
                how="left",
                validate="many_to_one",
            )
    )

    # Derived metrics
    merged["gross_profit_usd"] = merged["sales_usd"] - merged["cogs_usd"]
    merged["gross_margin_pct"] = merged["gross_profit_usd"] / merged["sales_usd"]
    merged["year"] = merged["date_time"].dt.year
    merged["month"] = merged["date_time"].dt.month
    merged["year_month"] = merged["date_time"].dt.strftime("%Y-%m")

    return merged


def run_quality_checks(df: pd.DataFrame) -> None:
    required = ["product_id", "account_id", "date_time", "sales_usd", "cogs_usd"]
    missing_required = df[required].isna().sum()
    if missing_required.any():
        raise ValueError(f"Missing values found in required fields:\n{missing_required}")

    if (df["sales_usd"] < 0).any():
        raise ValueError("Negative sales detected. Please review source data.")

    if (df["cogs_usd"] < 0).any():
        raise ValueError("Negative COGS detected. Please review source data.")


def export_outputs(df: pd.DataFrame) -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    clean_file = OUTPUT_DIR / "plant_co_sales_clean.csv"
    summary_file = OUTPUT_DIR / "plant_co_monthly_summary.csv"

    df.to_csv(clean_file, index=False)

    monthly_summary = (
        df.groupby(["year_month", "produt_type"], dropna=False)
          .agg(
              sales_usd=("sales_usd", "sum"),
              gross_profit_usd=("gross_profit_usd", "sum"),
              quantity=("quantity", "sum"),
          )
          .reset_index()
    )
    monthly_summary["gross_margin_pct"] = (
        monthly_summary["gross_profit_usd"] / monthly_summary["sales_usd"]
    )
    monthly_summary.to_csv(summary_file, index=False)

    print(f"Saved clean flat file to: {clean_file}")
    print(f"Saved monthly summary to: {summary_file}")


def main() -> None:
    fact, accounts, products = load_data()
    clean_df = transform(fact, accounts, products)
    run_quality_checks(clean_df)
    export_outputs(clean_df)
    print("Plant Co data cleaning completed successfully.")


if __name__ == "__main__":
    main()
