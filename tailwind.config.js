/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Modern Scientific Elegance Theme - Urban Biopeptides
        'theme-bg': '#FFFFFF',        // Pure White
        'theme-text': '#1F1F1F',      // Charcoal Black
        'theme-accent': '#4EC6C6',    // Cool Aqua / Teal Blue
        'theme-secondary': '#F3C6D3', // Soft Blush Pink

        // Primary color palette
        primary: {
          50: '#FFFFFF',
          100: '#F7F9FB',   // Soft Light Gray
          200: '#E8EEF2',
          300: '#D1D9E0',
          400: '#9CA8B3',
          500: '#4EC6C6',   // Teal (primary actions)
          600: '#3EB5B5',
          700: '#2EA3A3',
          800: '#1E8A8A',
          900: '#1F1F1F',   // Charcoal
        },

        // Pink accent palette (for highlights, buttons, accents)
        pink: {
          50: '#FDF7F9',
          100: '#FBF0F3',
          200: '#F8E1E8',
          300: '#F3C6D3',   // Main Blush Pink
          400: '#ED9BB3',
          500: '#E57093',
          600: '#D94D7A',
          700: '#C13A65',
          800: '#9E2F52',
          900: '#7D2543',
        },

        // Teal/Aqua palette (for primary actions, links)
        teal: {
          50: '#F0FAFA',
          100: '#E0F5F5',
          200: '#B3E8E8',
          300: '#80DADA',
          400: '#4EC6C6',   // Main Aqua Teal
          500: '#3EB5B5',
          600: '#2EA3A3',
          700: '#228888',
          800: '#1A6B6B',
          900: '#125050',
        },

        // Neutral grays
        neutral: {
          50: '#FFFFFF',
          100: '#F7F9FB',
          200: '#E8EEF2',
          300: '#D1D9E0',
          400: '#9CA8B3',
          500: '#6B7B8A',
          600: '#4E5A65',
          700: '#3A434B',
          800: '#272D33',
          900: '#1F1F1F',
        },

        // Keep gold mapping for backward compatibility (maps to pink)
        gold: {
          50: '#FDF7F9',
          100: '#FBF0F3',
          200: '#F8E1E8',
          300: '#F3C6D3',
          400: '#ED9BB3',
          500: '#E57093',
          600: '#D94D7A',
          700: '#C13A65',
          800: '#9E2F52',
          900: '#7D2543',
        },

        // Keep navy mapping (maps to teal)
        navy: {
          50: '#F0FAFA',
          100: '#E0F5F5',
          200: '#B3E8E8',
          300: '#80DADA',
          400: '#4EC6C6',
          500: '#3EB5B5',
          600: '#2EA3A3',
          700: '#228888',
          800: '#1A6B6B',
          900: '#125050',
        },

        accent: {
          light: '#F3C6D3',     // Blush Pink
          DEFAULT: '#4EC6C6',   // Aqua Teal
          dark: '#2EA3A3',
          white: '#ffffff',
          black: '#1F1F1F',
          pink: '#F3C6D3',
          teal: '#4EC6C6',
        },
      },
      fontFamily: {
        inter: ['Inter', 'sans-serif'],
      },
      boxShadow: {
        'soft': '0 2px 10px rgba(0, 0, 0, 0.03)',
        'medium': '0 4px 15px rgba(0, 0, 0, 0.05)',
        'hover': '0 8px 25px rgba(0, 0, 0, 0.08)',
      },
      animation: {
        'fadeIn': 'fadeIn 0.5s ease-out',
        'slideIn': 'slideIn 0.4s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0', transform: 'translateY(5px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideIn: {
          '0%': { opacity: '0', transform: 'translateX(-10px)' },
          '100%': { opacity: '1', transform: 'translateX(0)' },
        },
      },
    },
  },
  plugins: [],
}
