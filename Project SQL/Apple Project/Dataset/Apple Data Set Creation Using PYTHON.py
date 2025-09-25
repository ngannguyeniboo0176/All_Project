#pip install faker
from faker import Faker
import pandas as pd

# Initialize the Faker instance
fake = Faker()

# Define the specific Apple product categories
apple_categories = [
    {"Category_Id": f"CAT-{i+1}", "Category_Name": category} 
    for i, category in enumerate([
        "Laptop", "Audio", "Tablet", "Smartphone", "Wearable", "Streaming Device", "Desktop", "Subscription Service", "Smart Speaker", "Accessories"
    ])
]

# Convert to a DataFrame
df = pd.DataFrame(apple_categories)

# Save to CSV
df.to_csv("categories.csv", index=False)
print("Data saved to apple_product_categories.csv")

##################################################################################

"""   products Table   """
from faker import Faker
import pandas as pd

# Initialize Faker instance
fake = Faker()

# Define product categories with Category ID and Category Name
apple_categories = [
    {"Category_Id": 1, "Category_Name": "Laptop"}, 
    {"Category_Id": 2, "Category_Name": "Audio"}, 
    {"Category_Id": 3, "Category_Name": "Tablet"}, 
    {"Category_Id": 4, "Category_Name": "Smartphone"}, 
    {"Category_Id": 5, "Category_Name": "Wearable"}, 
    {"Category_Id": 6, "Category_Name": "Streaming Device"}, 
    {"Category_Id": 7, "Category_Name": "Desktop"}, 
    {"Category_Id": 8, "Category_Name": "Subscription Service"}, 
    {"Category_Id": 9, "Category_Name": "Smart Speaker"}, 
    {"Category_Id": 10, "Category_Name": "Accessories"} 
]

# Define products with corresponding category
apple_products = {
    "CAT-1": ["MacBook", "MacBook Air (M1)", "MacBook Air (M2)", "MacBook Pro 13-inch", "MacBook Pro 14-inch",  
        "MacBook Pro 16-inch", "MacBook (Retina)", "MacBook Air (Retina)", "MacBook Pro (Touch Bar)", "MacBook (Early 2015)"],
    "CAT-2": ["AirPods (2nd Generation)", "AirPods (3rd Generation)", "AirPods Pro", "AirPods Pro (2nd Generation)",  
        "AirPods Max", "Beats Studio Buds", "Beats Fit Pro", "Beats Solo Pro", "Beats Powerbeats Pro", 
        "HomePod (2nd Generation)", "HomePod mini"],
    "CAT-3": ["iPad (10th Generation)", "iPad (9th Generation)", "iPad mini (6th Generation)", "iPad mini (5th Generation)", 
        "iPad Air (5th Generation)", "iPad Air (4th Generation)", "iPad Pro 11-inch", "iPad Pro 12.9-inch", 
        "iPad Pro (M1)", "iPad Pro (M2)"],
    "CAT-4": ["iPhone 14", "iPhone 14 Plus", "iPhone 14 Pro", "iPhone 14 Pro Max", "iPhone 13", "iPhone 13 mini", 
        "iPhone 13 Pro", "iPhone 13 Pro Max", "iPhone SE (3rd Generation)", "iPhone 12", "iPhone 12 mini", 
        "iPhone 12 Pro", "iPhone 12 Pro Max"],
    "CAT-5": ["Apple Watch Series 9", "Apple Watch Ultra", "Apple Watch SE", "Apple Watch Nike Edition", "Apple Watch Hermès", 
        "Apple Watch Series 8", "Apple Watch Series 7", "Apple Watch Series 6", "Apple Watch Series 5"],
    "CAT-6": ["Apple TV 4K", "Apple TV HD", "Apple TV (3rd Generation)"],
    "CAT-7": ["iMac 24-inch", "iMac 27-inch", "iMac Pro", "iMac with Retina Display", "Mac Pro (2023)", "Mac Pro (Tower)", 
        "Mac Pro (Rack)", "Mac Studio", "Mac Mini", "Mac Mini (M2)"],
    "CAT-8": ["iCloud", "Apple Music", "Apple TV+", "Apple Fitness+", "Apple Arcade", "Apple News+", "Apple One"],
    "CAT-9": ["HomePod", "HomePod mini"],
    "CAT-10": ["Magic Keyboard", "Magic Keyboard with Touch ID", "Magic Mouse", "Magic Trackpad", "Apple Pencil (1st Generation)", 
        "Apple Pencil (2nd Generation)", "Smart Keyboard Folio", "Smart Cover for iPad", "Leather Case for iPhone", 
        "Silicone Case for iPhone", "MagSafe Battery Pack", "MagSafe Charger", "AirTag", "Lightning to USB Cable"]
}

# Generate product data
products_data = []
product_id = 1
for category_id, product_names in apple_products.items():
    for product_name in product_names:
        products_data.append({
            "Product_ID": f"P-{product_id}",  # Modified Product_ID format
            "Product_Name": product_name,
            "Category_ID": category_id,
            "Launch_Date": fake.date_this_decade(),
            "Price": fake.random_int(min=100, max=2000)
        })
        product_id += 1

# Convert to DataFrame
df = pd.DataFrame(products_data)

# Save to CSV
df.to_csv("products.csv", index=False)
print("Data saved to apple_products_detailed.csv")

####################################################################################

"""    Store   """

import pandas as pd

# Define Apple store locations with store information
apple_stores = [
    # United States
    ("Apple Fifth Avenue", "New York", "United States"),
    ("Apple Union Square", "San Francisco", "United States"),
    ("Apple Michigan Avenue", "Chicago", "United States"),
    ("Apple The Grove", "Los Angeles", "United States"),
    ("Apple SoHo", "New York", "United States"),
    ("Apple Grand Central", "New York", "United States"),
    ("Apple Beverly Center", "Los Angeles", "United States"),
    ("Apple Pioneer Place", "Portland", "United States"),
    ("Apple Park Visitor Center", "Cupertino", "United States"),
    ("Apple South Coast Plaza", "Costa Mesa", "United States"),
    ("Apple Ala Moana", "Honolulu", "United States"),
    ("Apple North Michigan Avenue", "Chicago", "United States"),
    ("Apple Walnut Street", "Philadelphia", "United States"),
    ("Apple The Americana at Brand", "Glendale", "United States"),
    ("Apple Downtown Brooklyn", "Brooklyn", "United States"),

    # Europe
    ("Apple Regent Street", "London", "United Kingdom"),
    ("Apple Covent Garden", "London", "United Kingdom"),
    ("Apple Champs-Elysees", "Paris", "France"),
    ("Apple Opera", "Paris", "France"),
    ("Apple Kaerntner Strasse", "Vienna", "Austria"),
    ("Apple Passeig de Gracia", "Barcelona", "Spain"),
    ("Apple Piazza Liberty", "Milan", "Italy"),
    ("Apple Via del Corso", "Rome", "Italy"),
    ("Apple Kurfuerstendamm", "Berlin", "Germany"),
    ("Apple Schildergasse", "Cologne", "Germany"),
    ("Apple Leidseplein", "Amsterdam", "Netherlands"),
    ("Apple Rosenstrasse", "Munich", "Germany"),
    ("Apple Brompton Road", "London", "United Kingdom"),
    ("Apple Galeries Lafayette", "Paris", "France"),
    ("Apple Dubai Mall", "Dubai", "UAE"),

    # Asia-Pacific
    ("Apple Shinjuku", "Tokyo", "Japan"),
    ("Apple Omotesando", "Tokyo", "Japan"),
    ("Apple Marunouchi", "Tokyo", "Japan"),
    ("Apple Fukuoka", "Fukuoka", "Japan"),
    ("Apple Shanghai IFC", "Shanghai", "China"),
    ("Apple Nanjing East", "Shanghai", "China"),
    ("Apple Sanlitun", "Beijing", "China"),
    ("Apple Taikoo Li", "Chengdu", "China"),
    ("Apple Taipei 101", "Taipei", "Taiwan"),
    ("Apple Causeway Bay", "Hong Kong", "China"),
    ("Apple Central World", "Bangkok", "Thailand"),
    ("Apple Orchard Road", "Singapore", "Singapore"),
    ("Apple Cotai Central", "Macau", "China"),
    ("Apple Kyoto", "Kyoto", "Japan"),
    ("Apple Jewel Changi Airport", "Singapore", "Singapore"),

    # Canada
    ("Apple Eaton Centre", "Toronto", "Canada"),
    ("Apple Rideau Centre", "Ottawa", "Canada"),
    ("Apple Sainte-Catherine", "Montreal", "Canada"),
    ("Apple Yorkdale", "Toronto", "Canada"),
    ("Apple Metrotown", "Burnaby", "Canada"),

    # Australia
    ("Apple Sydney", "Sydney", "Australia"),
    ("Apple Chadstone", "Melbourne", "Australia"),
    ("Apple Brisbane", "Brisbane", "Australia"),
    ("Apple Bondi", "Bondi", "Australia"),
    ("Apple Highpoint", "Melbourne", "Australia"),
    ("Apple Southland", "Cheltenham", "Australia"),

    # Middle East
    ("Apple Yas Mall", "Abu Dhabi", "UAE"),
    ("Apple The Dubai Mall", "Dubai", "UAE"),
    ("Apple Mall of the Emirates", "Dubai", "UAE"),

    # Latin America
    ("Apple Antara", "Mexico City", "Mexico"),
    ("Apple Santa Fe", "Mexico City", "Mexico"),
    ("Apple Via Santa Fe", "Mexico City", "Mexico"),
    ("Apple Parque La Colina", "Bogota", "Colombia"),
    ("Apple Andino", "Bogota", "Colombia"),

    # Additional Locations
    ("Apple Iconsiam", "Bangkok", "Thailand"),
    ("Apple Orchard Road", "Singapore", "Singapore"),
    ("Apple Chadstone", "Melbourne", "Australia"),
    ("Apple Champs-Elysees", "Paris", "France"),
    ("Apple The Dubai Mall", "Dubai", "UAE"),
    ("Apple Gangnam", "Seoul", "South Korea"),
    ("Apple Yeouido", "Seoul", "South Korea"),
    ("Apple Kumamoto", "Kumamoto", "Japan"),
    ("Apple Covent Garden", "London", "United Kingdom"),
    ("Apple Central World", "Bangkok", "Thailand"),
    ("Apple Beijing SKP", "Beijing", "China"),
]

# Create a DataFrame with Store_ID, Store_Name, City, Country
store_data = pd.DataFrame([
    {"Store_ID": f"ST-{idx + 1}", "Store_Name": name, "City": city, "Country": country}
    for idx, (name, city, country) in enumerate(apple_stores)
])

# Display the store data table
print(store_data)

# Optionally, save the data to a CSV or Excel file
store_data.to_csv("apple_stores.csv", index=False)

#######################################################################################
"""    Sales Table    """

from faker import Faker
import pandas as pd
import random
import string

# Initialize Faker
fake = Faker()

# Generate a list of Store IDs and Product IDs as per the format
store_ids = [f"ST-{i+1}" for i in range(75)]
category_ids = [f"CAT-{i+1}" for i in range(10)]  # 10 categories
product_ids = [f"P-{i+1}" for i in range(89)]  # 89 products

# Function to generate unique Sales_Id with 2 alphabets and 4 to 6 digits
def generate_unique_sales_id(existing_ids):
    while True:
        num_digits = random.randint(4, 6)  # Choose a random number of digits between 4 and 6
        sales_id = ''.join(random.choices(string.ascii_uppercase, k=2)) + '-' + ''.join(random.choices(string.digits, k=num_digits))
        if sales_id not in existing_ids:
            existing_ids.add(sales_id)
            return sales_id

# Set to keep track of unique Sales_Id values
unique_sales_ids = set()
sales_data = []

# Generate sales data
for _ in range(1040200):  # 10.4 Lakh rows
    sales_id = generate_unique_sales_id(unique_sales_ids)
    sale_date = fake.date_this_decade()
    store_id = random.choice(store_ids)
    product_id = random.choice(product_ids)
    quantity = random.randint(1, 10)  # Quantity between 1 and 10
    sales_data.append([sales_id, sale_date, store_id, product_id, quantity])

# Create a DataFrame
sales_df = pd.DataFrame(sales_data, columns=["Sales_Id", "Sale_Date", "Store_Id", "Product_Id", "Quantity"])

# Save to CSV
sales_df.to_csv("sales.csv", index=False)

###########################################################################################

"""    Warranty    """

import pandas as pd
from faker import Faker
import random

# Initialize Faker
fake = Faker()

# Load sale_id data from a CSV file
# Ensure that this file has at least 30,000 sale_id values
sale_data = pd.read_csv('C:/Users/anand/Desktop/SQL_1st_Pro/id.csv')
sale_ids_from_csv = sale_data['sale_id'].tolist()

# Check if the number of sale IDs is sufficient
if len(sale_ids_from_csv) < 30000:
    raise ValueError("The CSV file should contain at least 30,000 unique sale IDs.")

# Set number of records to generate
num_records = 30000

# Create sets to hold generated claim_ids to ensure uniqueness
claim_ids = set()
claim_dates = []
repair_statuses = []

# Define possible repair statuses
repair_status_options = ['Pending', 'In Progress', 'Completed', 'Rejected']

# Generate unique claim IDs and other data
while len(claim_ids) < num_records:
    # Randomly select a 3, 4, or 5-digit number
    num_digits = random.choice([3, 4, 5])
    claim_number = random.randint(10**(num_digits - 1), 10**num_digits - 1)
    claim_id = f"CL-{claim_number}"

    # Ensure the claim_id is unique
    if claim_id not in claim_ids:
        claim_ids.add(claim_id)
        claim_date = fake.date_this_year()
        repair_status = random.choice(repair_status_options)

        claim_dates.append(claim_date)
        repair_statuses.append(repair_status)

# Convert claim_ids set to a list for DataFrame creation
claim_ids = list(claim_ids)

# Create DataFrame
warranty_data = pd.DataFrame({
    'claim_id': claim_ids,
    'claim_date': claim_dates,
    'sale_id': sale_ids_from_csv[:num_records],  # Use only the first 30,000 sale IDs
    'repair_status': repair_statuses
})

# Display the first few rows
print(warranty_data.head())

# Optionally, save to a CSV file
warranty_data.to_csv('generated_warranty_data.csv', index=False)
