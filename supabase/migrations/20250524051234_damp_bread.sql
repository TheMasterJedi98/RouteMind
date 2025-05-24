-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Update updated_at column function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Warehouses table
CREATE TABLE IF NOT EXISTS warehouses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  capacity INTEGER NOT NULL CHECK (capacity > 0),
  address TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  user_id UUID NOT NULL REFERENCES auth.users(id)
);

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'idx_warehouses_user_id'
  ) THEN
    CREATE INDEX idx_warehouses_user_id ON warehouses(user_id);
  END IF;
END $$;

ALTER TABLE warehouses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own warehouses" ON warehouses;
CREATE POLICY "Users can view their own warehouses"
  ON warehouses
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own warehouses" ON warehouses;
CREATE POLICY "Users can insert their own warehouses"
  ON warehouses
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own warehouses" ON warehouses;
CREATE POLICY "Users can update their own warehouses"
  ON warehouses
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own warehouses" ON warehouses;
CREATE POLICY "Users can delete their own warehouses"
  ON warehouses
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

DROP TRIGGER IF EXISTS update_warehouses_updated_at ON warehouses;
CREATE TRIGGER update_warehouses_updated_at
  BEFORE UPDATE ON warehouses
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Stores table
CREATE TABLE IF NOT EXISTS stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  demand INTEGER NOT NULL CHECK (demand > 0),
  address TEXT NOT NULL,
  time_window_start TIME WITHOUT TIME ZONE,
  time_window_end TIME WITHOUT TIME ZONE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  user_id UUID NOT NULL REFERENCES auth.users(id)
);

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'idx_stores_user_id'
  ) THEN
    CREATE INDEX idx_stores_user_id ON stores(user_id);
  END IF;
END $$;

ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own stores" ON stores;
CREATE POLICY "Users can view their own stores"
  ON stores
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own stores" ON stores;
CREATE POLICY "Users can insert their own stores"
  ON stores
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own stores" ON stores;
CREATE POLICY "Users can update their own stores"
  ON stores
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own stores" ON stores;
CREATE POLICY "Users can delete their own stores"
  ON stores
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

DROP TRIGGER IF EXISTS update_stores_updated_at ON stores;
CREATE TRIGGER update_stores_updated_at
  BEFORE UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trucks table
CREATE TABLE IF NOT EXISTS trucks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  capacity INTEGER NOT NULL CHECK (capacity > 0),
  speed INTEGER NOT NULL CHECK (speed > 0),
  warehouse_id UUID NOT NULL REFERENCES warehouses(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  user_id UUID NOT NULL REFERENCES auth.users(id)
);

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trucks_warehouse_id'
  ) THEN
    CREATE INDEX idx_trucks_warehouse_id ON trucks(warehouse_id);
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'idx_trucks_user_id'
  ) THEN
    CREATE INDEX idx_trucks_user_id ON trucks(user_id);
  END IF;
END $$;

ALTER TABLE trucks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own trucks" ON trucks;
CREATE POLICY "Users can view their own trucks"
  ON trucks
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own trucks" ON trucks;
CREATE POLICY "Users can insert their own trucks"
  ON trucks
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own trucks" ON trucks;
CREATE POLICY "Users can update their own trucks"
  ON trucks
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own trucks" ON trucks;
CREATE POLICY "Users can delete their own trucks"
  ON trucks
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

DROP TRIGGER IF EXISTS update_trucks_updated_at ON trucks;
CREATE TRIGGER update_trucks_updated_at
  BEFORE UPDATE ON trucks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Routes table
CREATE TABLE IF NOT EXISTS routes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  warehouse_id UUID NOT NULL REFERENCES warehouses(id) ON DELETE CASCADE,
  truck_id UUID NOT NULL REFERENCES trucks(id) ON DELETE CASCADE,
  distance DOUBLE PRECISION NOT NULL CHECK (distance >= 0),
  estimated_time DOUBLE PRECISION NOT NULL CHECK (estimated_time >= 0),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  user_id UUID NOT NULL REFERENCES auth.users(id)
);

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'idx_routes_warehouse_id'
  ) THEN
    CREATE INDEX idx_routes_warehouse_id ON routes(warehouse_id);
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'idx_routes_truck_id'
  ) THEN
    CREATE INDEX idx_routes_truck_id ON routes(truck_id);
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'idx_routes_user_id'
  ) THEN
    CREATE INDEX idx_routes_user_id ON routes(user_id);
  END IF;
END $$;

ALTER TABLE routes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own routes" ON routes;
CREATE POLICY "Users can view their own routes"
  ON routes
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own routes" ON routes;
CREATE POLICY "Users can insert their own routes"
  ON routes
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own routes" ON routes;
CREATE POLICY "Users can update their own routes"
  ON routes
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own routes" ON routes;
CREATE POLICY "Users can delete their own routes"
  ON routes
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

DROP TRIGGER IF EXISTS update_routes_updated_at ON routes;
CREATE TRIGGER update_routes_updated_at
  BEFORE UPDATE ON routes
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Route Stores junction table
CREATE TABLE IF NOT EXISTS route_stores (
  route_id UUID REFERENCES routes(id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  sequence_number INTEGER NOT NULL CHECK (sequence_number >= 0),
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (route_id, store_id)
);

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'idx_route_stores_store_id'
  ) THEN
    CREATE INDEX idx_route_stores_store_id ON route_stores(store_id);
  END IF;
END $$;

ALTER TABLE route_stores ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their route stores" ON route_stores;
CREATE POLICY "Users can view their route stores"
  ON route_stores
  FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM routes 
    WHERE routes.id = route_stores.route_id 
    AND routes.user_id = auth.uid()
  ));

DROP POLICY IF EXISTS "Users can insert their route stores" ON route_stores;
CREATE POLICY "Users can insert their route stores"
  ON route_stores
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (
    SELECT 1 FROM routes 
    WHERE routes.id = route_stores.route_id 
    AND routes.user_id = auth.uid()
  ));

DROP POLICY IF EXISTS "Users can delete their route stores" ON route_stores;
CREATE POLICY "Users can delete their route stores"
  ON route_stores
  FOR DELETE
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM routes 
    WHERE routes.id = route_stores.route_id 
    AND routes.user_id = auth.uid()
  ));