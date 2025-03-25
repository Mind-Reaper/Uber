//
//  SupabaseManager.swift
//  Uber
//
//  Created by Daniel Onadipe on 3/5/25.
//

import Foundation
import Supabase


class SupabaseManager {
    
    
    
    static private let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://hdlzoggcbwwbjjmbjdjk.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhkbHpvZ2djYnd3YmpqbWJqZGprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDExMzg5MzcsImV4cCI6MjA1NjcxNDkzN30.CrUEt42KExachmGx3T92xKiukUw1dllg1iF1iLVtekQ"
    )
    
    static var auth: AuthClient {
        return supabase.auth
    }
    
    
    static func table(_ table: String) -> PostgrestQueryBuilder {
        return supabase.from(table);
    }
    
    static func channel(_ channel: String) -> RealtimeChannelV2 {
        return supabase.channel(channel)
    }
    
    static func channel(_ channel: String,
                        options: @Sendable (inout RealtimeChannelConfig) -> Void = { _ in }
    ) -> RealtimeChannelV2 {
        return supabase.channel(channel, options: options)
    }
    
    
}
