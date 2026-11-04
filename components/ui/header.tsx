'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { SAN_FRANCISCO_COLLECTIBLES } from '@/lib/data';
import { useUserData } from '@/lib/use-user-data';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { useState, useEffect } from 'react';

export function Header() {
  const pathname = usePathname();
  const { userData } = useUserData();
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  const totalCollectibles = SAN_FRANCISCO_COLLECTIBLES.length;
  const progress = isClient ? userData.totalCollected : 0;

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-16 items-center justify-between px-4">
        <div className="flex items-center space-x-4">
          <Link href="/" className="flex items-center space-x-2">
            <span className="text-2xl font-bold bg-gradient-to-r from-sfPrimary to-sfSecondary bg-clip-text text-transparent">
              San Funcisco
            </span>
          </Link>
          <nav className="hidden md:flex items-center space-x-2">
            <Link href="/">
              <Button
                variant={pathname === '/' ? 'sfPrimary' : 'ghost'}
                size="sm"
              >
                Map
              </Button>
            </Link>
            <Link href="/album">
              <Button
                variant={pathname === '/album' ? 'sfPrimary' : 'ghost'}
                size="sm"
              >
                Album ({progress}/{totalCollectibles})
              </Button>
            </Link>
            <Link href="/rewards">
              <Button
                variant={pathname === '/rewards' ? 'sfPrimary' : 'ghost'}
                size="sm"
              >
                Rewards
              </Button>
            </Link>
          </nav>
        </div>
        <div className="flex items-center space-x-4">
          <Badge className="bg-sfPrimary">
            Welcome, {userData.username}!
          </Badge>
        </div>
      </div>
    </header>
  );
}
