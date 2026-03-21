// open mongodb and create database {with any name} and create a collection name {product}

// OP1: insertMany() – insert all 3 documents

db.products.insertMany([
  {
    product_id: "E101",
    name: "Samsung Smart TV",
    category: "Electronics",
    price: 45000,
    brand: "Samsung",
    warranty_years: 2,
    specifications: {
      screen_size: "55 inch",
      resolution: "4K",
      voltage: "220V"
    },
    features: ["Smart TV", "WiFi", "Bluetooth"]
  },
  {
    product_id: "C201",
    name: "Men's Denim Jacket",
    category: "Clothing",
    price: 2500,
    brand: "Levis",
    size_options: ["S", "M", "L", "XL"],
    material: "Denim",
    colors: ["Blue", "Black"]
  },
  {
    product_id: "G301",
    name: "Organic Milk",
    category: "Groceries",
    price: 60,
    brand: "Amul",
    expiry_date: ISODate("2024-11-20"),
    nutrition: {
      calories: 150,
      protein: "8g",
      fat: "7g"
    },
    pack_size: "1 Liter"
  }
]);


// OP2: find() – retrieve all Electronics products with price > 20000

db.products.find({
  category: "Electronics",
  price: { $gt: 20000 }
});


// OP3: find() – retrieve all Groceries expiring before 2025-01-01

db.products.find({
  category: "Groceries",
  expiry_date: { $lt: ISODate("2025-01-01") }
});

                // db.products.find({
                //   category: "Groceries",
                //   expiry_date: { $lt: "2025-01-01" }
                // });


// OP4: updateOne() – add a "discount_percent" field to a specific product

db.products.updateOne(
  { product_id: "E101" },
  { $set: { discount_percent: 10 } }
);


// OP5: createIndex() – create an index on category field

db.products.createIndex({ category: 1 });
