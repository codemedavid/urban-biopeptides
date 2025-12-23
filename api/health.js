import { createClient } from '@supabase/supabase-js';

export default async function handler(req, res) {
    // Set CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    const startTime = Date.now();
    const supabaseUrl = process.env.VITE_SUPABASE_URL;
    const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY;

    if (!supabaseUrl || !supabaseAnonKey) {
        return res.status(500).json({
            status: 'error',
            message: 'Missing Supabase configuration',
            timestamp: new Date().toISOString()
        });
    }

    try {
        const supabase = createClient(supabaseUrl, supabaseAnonKey);

        // Perform a simple health check query - just count products
        const { data, error } = await supabase
            .from('products')
            .select('id', { count: 'exact', head: true });

        const responseTime = Date.now() - startTime;

        if (error) {
            console.error('Database health check failed:', error);
            return res.status(500).json({
                status: 'unhealthy',
                message: error.message,
                responseTime: `${responseTime}ms`,
                timestamp: new Date().toISOString()
            });
        }

        // Success response
        return res.status(200).json({
            status: 'healthy',
            message: 'Database is active and responding',
            responseTime: `${responseTime}ms`,
            timestamp: new Date().toISOString(),
            checkedAt: new Date().toLocaleString('en-PH', { timeZone: 'Asia/Manila' })
        });

    } catch (err) {
        const responseTime = Date.now() - startTime;
        console.error('Health check error:', err);

        return res.status(500).json({
            status: 'error',
            message: err.message || 'Unknown error occurred',
            responseTime: `${responseTime}ms`,
            timestamp: new Date().toISOString()
        });
    }
}
