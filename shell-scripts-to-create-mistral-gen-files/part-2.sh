#!/bin/bash
set -e
echo "🎨 Creating Tailwind config and global styles..."

cat > tailwind.config.ts << 'ENDOFFILE'
import type { Config } from 'tailwindcss';
const config: Config = {
  darkMode: ['class'],
  content: ['./pages/**/*.{ts,tsx}', './components/**/*.{ts,tsx}', './app/**/*.{ts,tsx}', './src/**/*.{ts,tsx}'],
  theme: {
    container: { center: true, padding: '2rem', screens: { '2xl': '1400px' } },
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: { DEFAULT: 'hsl(var(--primary))', foreground: 'hsl(var(--primary-foreground))' },
        secondary: { DEFAULT: 'hsl(var(--secondary))', foreground: 'hsl(var(--secondary-foreground))' },
        destructive: { DEFAULT: 'hsl(var(--destructive))', foreground: 'hsl(var(--destructive-foreground))' },
        muted: { DEFAULT: 'hsl(var(--muted))', foreground: 'hsl(var(--muted-foreground))' },
        accent: { DEFAULT: 'hsl(var(--accent))', foreground: 'hsl(var(--accent-foreground))' },
        popover: { DEFAULT: 'hsl(var(--popover))', foreground: 'hsl(var(--popover-foreground))' },
        card: { DEFAULT: 'hsl(var(--card))', foreground: 'hsl(var(--card-foreground))' },
        sfPrimary: '#FF6B6B',
        sfSecondary: '#4ECDC4',
        sfAccent: '#FFE66D',
        sfDark: '#2C3E50',
      },
      borderRadius: { lg: 'var(--radius)', md: 'calc(var(--radius) - 2px)', sm: 'calc(var(--radius) - 4px)' },
      keyframes: {
        'accordion-down': { from: { height: '0' }, to: { height: 'var(--radix-accordion-content-height)' } },
        'accordion-up': { from: { height: 'var(--radix-accordion-content-height)' }, to: { height: '0' } },
      },
      animation: { 'accordion-down': 'accordion-down 0.2s ease-out', 'accordion-up': 'accordion-up 0.2s ease-out' },
    },
  },
  plugins: [require('tailwindcss-animate')],
};
export default config;
ENDOFFILE

cat > app/globals.css << 'ENDOFFILE'
@tailwind base;
@tailwind components;
@tailwind utilities;
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap');

@layer base {
  :root {
    --background: 0 0% 100%; --foreground: 240 10% 3.9%;
    --card: 0 0% 100%; --card-foreground: 240 10% 3.9%;
    --popover: 0 0% 100%; --popover-foreground: 240 10% 3.9%;
    --primary: 0 72% 65%; --primary-foreground: 0 0% 100%;
    --secondary: 174 81% 50%; --secondary-foreground: 0 0% 100%;
    --muted: 240 4% 96%; --muted-foreground: 240 4% 46%;
    --accent: 45 93% 72%; --accent-foreground: 240 10% 3.9%;
    --destructive: 0 84% 60%; --destructive-foreground: 0 0% 100%;
    --border: 240 5% 90%; --input: 240 5% 90%; --ring: 240 10% 3.9%; --radius: 0.5rem;
  }
  .dark {
    --background: 240 10% 3.9%; --foreground: 0 0% 98%;
    --card: 240 10% 6%; --card-foreground: 0 0% 98%;
    --popover: 240 10% 6%; --popover-foreground: 0 0% 98%;
    --primary: 0 72% 65%; --primary-foreground: 0 0% 98%;
    --secondary: 174 81% 50%; --secondary-foreground: 0 0% 98%;
    --muted: 240 5% 15%; --muted-foreground: 240 5% 65%;
    --accent: 45 93% 72%; --accent-foreground: 0 0% 98%;
    --destructive: 0 62% 30%; --destructive-foreground: 0 0% 98%;
    --border: 240 5% 20%; --input: 240 5% 20%; --ring: 240 10% 3.9%;
  }
}
@layer base {
  * { @apply border-border; }
  body { @apply bg-background text-foreground; font-family: 'Poppins', sans-serif; }
}
::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-track { background: #f1f1f1; }
::-webkit-scrollbar-thumb { background: #888; border-radius: 4px; }
::-webkit-scrollbar-thumb:hover { background: #555; }
ENDOFFILE

echo "📱 Creating app files..."

cat > app/layout.tsx << 'ENDOFFILE'
import type { Metadata } from 'next';
import { Poppins } from 'next/font/google';
import './globals.css';
import { Toaster } from '@/components/ui/toaster';

const poppins = Poppins({ weight: ['300', '400', '600', '700'], subsets: ['latin'], display: 'swap', variable: '--font-sans' });

export const metadata: Metadata = {
  title: 'San Funcisco - Tour Simulator',
  description: 'Digital collectibles for San Francisco tours - Click to collect!',
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode; }>) {
  return (
    <html lang="en">
      <body className={`${poppins.className} antialiased`}>
        {children}
        <Toaster />
      </body>
    </html>
  );
}
ENDOFFILE

cat > app/page.tsx << 'ENDOFFILE'
import { MapView } from '@/components/map-view';
import { Header } from '@/components/header';
export default function Home() {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="flex-1"><MapView /></main>
    </div>
  );
}
ENDOFFILE

cat > app/album/page.tsx << 'ENDOFFILE'
import { AlbumView } from '@/components/album-view';
import { Header } from '@/components/header';
export default function AlbumPage() {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="flex-1"><AlbumView /></main>
    </div>
  );
}
ENDOFFILE

cat > app/rewards/page.tsx << 'ENDOFFILE'
import { RewardsView } from '@/components/rewards-view';
import { Header } from '@/components/header';
export default function RewardsPage() {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="flex-1"><RewardsView /></main>
    </div>
  );
}
ENDOFFILE

echo "✅ Part 2 complete: App files and Tailwind created!"