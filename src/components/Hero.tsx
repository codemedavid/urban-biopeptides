import React, { useState, useEffect } from 'react';
import { ArrowRight, ShieldCheck, Truck, Clock, Sparkles, FlaskConical, Award } from 'lucide-react';
import { useSiteSettings } from '../hooks/useSiteSettings';

interface HeroProps {
  onShopAll: () => void;
}

const Hero: React.FC<HeroProps> = ({ onShopAll }) => {
  const [isVisible, setIsVisible] = useState(false);
  const { siteSettings } = useSiteSettings();

  useEffect(() => {
    setIsVisible(true);
  }, []);

  // Use settings or fallbacks if loading/missing
  const badgeText = siteSettings?.hero_badge_text || 'Premium Peptide Solutions';
  const titleHighlight = siteSettings?.hero_title_highlight || 'Peptides';
  const subtext = siteSettings?.hero_subtext || 'From the Lab to You — Simplifying Science, One Dose at a Time.';

  return (
    <div className="relative overflow-hidden">
      {/* Gradient Background */}
      <div className="absolute inset-0 bg-gradient-to-br from-teal-50 via-white to-pink-50" />

      {/* Animated Background Elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {/* Large Teal Circle */}
        <div className="absolute -top-32 -right-32 w-96 h-96 bg-gradient-to-br from-teal-400/20 to-teal-500/10 rounded-full blur-3xl animate-pulse" />
        {/* Pink Accent */}
        <div className="absolute bottom-0 left-1/4 w-72 h-72 bg-gradient-to-t from-pink-300/20 to-transparent rounded-full blur-3xl" />
        {/* Floating Pills */}
        <div className="hidden md:block absolute top-20 left-10 w-16 h-16 bg-white/60 backdrop-blur-sm rounded-2xl rotate-12 shadow-lg border border-teal-200/50" />
        <div className="hidden md:block absolute top-40 right-20 w-12 h-12 bg-pink-100/60 backdrop-blur-sm rounded-xl -rotate-6 shadow-lg border border-pink-200/50" />
        <div className="hidden md:block absolute bottom-32 left-20 w-10 h-10 bg-teal-100/60 backdrop-blur-sm rounded-lg rotate-45 shadow-lg border border-teal-200/50" />
        {/* Dotted Pattern */}
        <div className="absolute right-0 top-1/2 -translate-y-1/2 w-32 h-64 opacity-20">
          <div className="grid grid-cols-4 gap-3">
            {[...Array(16)].map((_, i) => (
              <div key={i} className="w-2 h-2 bg-teal-400 rounded-full" />
            ))}
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16 lg:py-20 relative z-10">
        <div className={`transition-all duration-1000 transform ${isVisible ? 'translate-y-0 opacity-100' : 'translate-y-10 opacity-0'}`}>

          {/* Main Content Grid */}
          <div className="grid lg:grid-cols-2 gap-8 lg:gap-12 items-center">

            {/* Left Column - Text Content */}
            <div className="space-y-6 text-center lg:text-left">
              {/* Badge */}
              <div className="inline-flex items-center gap-2 px-4 py-2 bg-white/80 backdrop-blur-sm rounded-full border-2 border-teal-400 shadow-lg shadow-teal-100/50">
                <Sparkles className="w-4 h-4 text-teal-500" />
                <span className="text-xs font-bold tracking-wide uppercase text-teal-700">
                  {badgeText}
                </span>
              </div>

              {/* Main Headline */}
              <div className="space-y-3">
                <h1 className="text-4xl md:text-5xl lg:text-6xl font-extrabold text-gray-900 leading-[1.1] tracking-tight">
                  Your One-Stop
                  <br />
                  <span className="relative inline-block">
                    <span className="bg-gradient-to-r from-teal-500 via-teal-400 to-pink-400 bg-clip-text text-transparent">
                      {titleHighlight}
                    </span>
                    {/* Underline decoration */}
                    <svg className="absolute w-full h-4 -bottom-2 left-0" viewBox="0 0 200 20" preserveAspectRatio="none">
                      <path d="M0 15 Q 50 5 100 15 T 200 15" stroke="url(#gradient)" strokeWidth="4" fill="none" strokeLinecap="round" />
                      <defs>
                        <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="0%">
                          <stop offset="0%" stopColor="#4EC6C6" />
                          <stop offset="100%" stopColor="#F3C6D3" />
                        </linearGradient>
                      </defs>
                    </svg>
                  </span>
                  {" "}Shop
                </h1>

                <p className="text-lg md:text-xl text-gray-500 font-medium italic max-w-lg mx-auto lg:mx-0">
                  {subtext}
                </p>
              </div>

              {/* CTA Button */}
              <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start pt-2">
                <button
                  onClick={onShopAll}
                  className="group relative px-8 py-4 bg-gradient-to-r from-teal-500 to-teal-600 text-white rounded-2xl font-bold text-lg shadow-xl shadow-teal-500/30 hover:shadow-2xl hover:shadow-teal-500/40 hover:-translate-y-1 transition-all duration-300 overflow-hidden"
                >
                  <div className="absolute inset-0 bg-gradient-to-r from-white/0 via-white/25 to-white/0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700" />
                  <span className="relative flex items-center justify-center gap-2">
                    Explore Products
                    <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                  </span>
                </button>
              </div>

              {/* Trust Badges Row */}
              <div className="flex flex-wrap justify-center lg:justify-start items-center gap-4 pt-4">
                <div className="flex items-center gap-2 text-sm font-medium text-gray-600 bg-white/60 backdrop-blur-sm px-3 py-2 rounded-lg border border-gray-100">
                  <ShieldCheck className="w-4 h-4 text-teal-500" />
                  <span>Lab Tested</span>
                </div>
                <div className="flex items-center gap-2 text-sm font-medium text-gray-600 bg-white/60 backdrop-blur-sm px-3 py-2 rounded-lg border border-gray-100">
                  <Truck className="w-4 h-4 text-teal-500" />
                  <span>Fast Delivery</span>
                </div>
                <div className="flex items-center gap-2 text-sm font-medium text-gray-600 bg-white/60 backdrop-blur-sm px-3 py-2 rounded-lg border border-gray-100">
                  <Clock className="w-4 h-4 text-pink-400" />
                  <span>24/7 Support</span>
                </div>
              </div>
            </div>

            {/* Right Column - Feature Cards */}
            <div className="relative hidden lg:block">
              {/* Main Feature Card */}
              <div className="relative bg-white/70 backdrop-blur-xl rounded-3xl shadow-2xl p-8 border border-white/80 transform hover:scale-[1.02] transition-transform duration-300">
                {/* Card Accent */}
                <div className="absolute -top-2 -right-2 w-20 h-20 bg-gradient-to-br from-teal-400 to-pink-300 rounded-2xl -z-10 opacity-60" />

                <div className="space-y-6">
                  {/* Feature 1 */}
                  <div className="flex items-start gap-4 p-4 bg-gradient-to-r from-teal-50 to-transparent rounded-xl">
                    <div className="p-3 bg-teal-500 rounded-xl shadow-lg shadow-teal-500/30">
                      <FlaskConical className="w-6 h-6 text-white" />
                    </div>
                    <div>
                      <h3 className="font-bold text-gray-900 mb-1">Research-Grade Quality</h3>
                      <p className="text-sm text-gray-600">High-purity peptides with verified lab testing</p>
                    </div>
                  </div>

                  {/* Feature 2 */}
                  <div className="flex items-start gap-4 p-4 bg-gradient-to-r from-pink-50 to-transparent rounded-xl">
                    <div className="p-3 bg-gradient-to-br from-pink-400 to-pink-500 rounded-xl shadow-lg shadow-pink-400/30">
                      <Award className="w-6 h-6 text-white" />
                    </div>
                    <div>
                      <h3 className="font-bold text-gray-900 mb-1">Community Trusted</h3>
                      <p className="text-sm text-gray-600">Thousands of satisfied customers nationwide</p>
                    </div>
                  </div>

                  {/* Feature 3 */}
                  <div className="flex items-start gap-4 p-4 bg-gradient-to-r from-teal-50 to-transparent rounded-xl">
                    <div className="p-3 bg-teal-500 rounded-xl shadow-lg shadow-teal-500/30">
                      <ShieldCheck className="w-6 h-6 text-white" />
                    </div>
                    <div>
                      <h3 className="font-bold text-gray-900 mb-1">Secure & Discreet</h3>
                      <p className="text-sm text-gray-600">Privacy-focused packaging and checkout</p>
                    </div>
                  </div>
                </div>

                {/* Decorative bottom */}
                <div className="absolute -bottom-3 left-1/2 -translate-x-1/2 w-3/4 h-6 bg-gradient-to-r from-teal-400/20 via-pink-300/20 to-teal-400/20 rounded-full blur-xl" />
              </div>

              {/* Floating Stats Card */}
              <div className="absolute -left-8 bottom-12 bg-white/90 backdrop-blur-xl rounded-2xl shadow-xl p-4 border border-teal-100 transform hover:scale-105 transition-transform">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-gradient-to-br from-teal-400 to-teal-500 rounded-xl flex items-center justify-center shadow-lg">
                    <span className="text-white font-bold text-lg">99%</span>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500 uppercase font-medium">Purity Rate</p>
                    <p className="font-bold text-gray-900">Lab Verified</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Mobile Feature Cards */}
          <div className="lg:hidden mt-8 grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div className="bg-white/70 backdrop-blur-sm rounded-xl p-4 border border-teal-100 shadow-lg">
              <FlaskConical className="w-8 h-8 text-teal-500 mb-2" />
              <h3 className="font-bold text-gray-900 text-sm">Research-Grade</h3>
              <p className="text-xs text-gray-500">Lab-tested purity</p>
            </div>
            <div className="bg-white/70 backdrop-blur-sm rounded-xl p-4 border border-pink-100 shadow-lg">
              <Award className="w-8 h-8 text-pink-400 mb-2" />
              <h3 className="font-bold text-gray-900 text-sm">Trusted</h3>
              <p className="text-xs text-gray-500">Community approved</p>
            </div>
            <div className="bg-white/70 backdrop-blur-sm rounded-xl p-4 border border-teal-100 shadow-lg">
              <ShieldCheck className="w-8 h-8 text-teal-500 mb-2" />
              <h3 className="font-bold text-gray-900 text-sm">Secure</h3>
              <p className="text-xs text-gray-500">Discreet shipping</p>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
};

export default Hero;
