export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      warehouses: {
        Row: {
          id: string
          name: string
          latitude: number
          longitude: number
          capacity: number
          address: string
          created_at: string | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          id?: string
          name: string
          latitude: number
          longitude: number
          capacity: number
          address: string
          created_at?: string | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          id?: string
          name?: string
          latitude?: number
          longitude?: number
          capacity?: number
          address?: string
          created_at?: string | null
          updated_at?: string | null
          user_id?: string
        }
      }
      stores: {
        Row: {
          id: string
          name: string
          latitude: number
          longitude: number
          demand: number
          address: string
          time_window_start: string | null
          time_window_end: string | null
          created_at: string | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          id?: string
          name: string
          latitude: number
          longitude: number
          demand: number
          address: string
          time_window_start?: string | null
          time_window_end?: string | null
          created_at?: string | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          id?: string
          name?: string
          latitude?: number
          longitude?: number
          demand?: number
          address?: string
          time_window_start?: string | null
          time_window_end?: string | null
          created_at?: string | null
          updated_at?: string | null
          user_id?: string
        }
      }
      trucks: {
        Row: {
          id: string
          name: string
          capacity: number
          speed: number
          warehouse_id: string
          created_at: string | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          id?: string
          name: string
          capacity: number
          speed: number
          warehouse_id: string
          created_at?: string | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          id?: string
          name?: string
          capacity?: number
          speed?: number
          warehouse_id?: string
          created_at?: string | null
          updated_at?: string | null
          user_id?: string
        }
      }
      routes: {
        Row: {
          id: string
          warehouse_id: string
          truck_id: string
          distance: number
          estimated_time: number
          created_at: string | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          id?: string
          warehouse_id: string
          truck_id: string
          distance: number
          estimated_time: number
          created_at?: string | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          id?: string
          warehouse_id?: string
          truck_id?: string
          distance?: number
          estimated_time?: number
          created_at?: string | null
          updated_at?: string | null
          user_id?: string
        }
      }
      route_stores: {
        Row: {
          route_id: string
          store_id: string
          sequence_number: number
          created_at: string | null
        }
        Insert: {
          route_id: string
          store_id: string
          sequence_number: number
          created_at?: string | null
        }
        Update: {
          route_id?: string
          store_id?: string
          sequence_number?: number
          created_at?: string | null
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}