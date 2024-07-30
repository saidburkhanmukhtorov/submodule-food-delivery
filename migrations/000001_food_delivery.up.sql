-- Products
CREATE TABLE products (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(10, 2) NOT NULL,
  image_url TEXT
);

-- Offices
CREATE TABLE offices (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address TEXT,
  latitude NUMERIC(10, 6),
  longitude NUMERIC(10, 6)
);

-- Baskets
CREATE TABLE baskets (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Basket Items
CREATE TABLE basket_items (
  id VARCHAR(255) PRIMARY KEY,
  basket_id VARCHAR(255) NOT NULL REFERENCES baskets(id),
  product_id VARCHAR(255) NOT NULL REFERENCES products(id),
  quantity INT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Orders
CREATE TABLE orders (
  id VARCHAR(255) PRIMARY KEY,
  client_id VARCHAR(255) NOT NULL,
  courier_id VARCHAR(255),
  office_id VARCHAR(255) NOT NULL REFERENCES offices(id),
  delivery_latitude NUMERIC(10, 6) NOT NULL,
  delivery_longitude NUMERIC(10, 6) NOT NULL,
  total_price NUMERIC(10, 2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Triggers for updating timestamps
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_baskets_updated_at
BEFORE UPDATE ON baskets
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at();

CREATE TRIGGER update_basket_items_updated_at
BEFORE UPDATE ON basket_items
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at();

CREATE TRIGGER update_orders_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at();