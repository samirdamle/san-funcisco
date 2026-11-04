#!/bin/bash
set -e
echo "🎯 Creating domain components..."

cat > components/header.tsx << 'ENDOFFILE'
'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { SAN_FRANCISCO_COLLECTIBLES } from '@/lib/data';
import { useUserData } from '@/lib/use-user-data';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
export function Header() {
  const pathname = usePathname();
  const { userData } = useUserData();
  const totalCollectibles = SAN_FRANCISCO_COLLECTIBLES.length;
  const progress = userData.totalCollected;
  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-16 items-center justify-between px-4">
        <div className="flex items-center space-x-4">
          <Link href="/" className="flex items-center space-x-2">
            <span className="text-2xl font-bold bg-gradient-to-r from-sfPrimary to-sfSecondary bg-clip-text text-transparent">San Funcisco</span>
          </Link>
          <nav className="hidden md:flex items-center space-x-2">
            <Link href="/"><Button variant={pathname === '/' ? 'sfPrimary' : 'ghost'} size="sm">Map</Button></Link>
            <Link href="/album"><Button variant={pathname === '/album' ? 'sfPrimary' : 'ghost'} size="sm">Album ({progress}/{totalCollectibles})</Button></Link>
            <Link href="/rewards"><Button variant={pathname === '/rewards' ? 'sfPrimary' : 'ghost'} size="sm">Rewards</Button></Link>
          </nav>
        </div>
        <div className="flex items-center space-x-4">
          <Badge className="bg-sfPrimary">Welcome, {userData.username}!</Badge>
        </div>
      </div>
    </header>
  );
}
ENDOFFILE

cat > components/collectible-modal.tsx << 'ENDOFFILE'
'use client';
import Image from 'next/image';
import { Collectible } from '@/lib/data';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
interface CollectibleModalProps { collectible: Collectible; isOpen: boolean; onClose: () => void; onCollect: () => void; isCollected: boolean; }
export function CollectibleModal({ collectible, isOpen, onClose, onCollect, isCollected }: CollectibleModalProps) {
  const getRarityVariant = (rarity: string) => {
    switch (rarity) { case 'Common': return 'common'; case 'Rare': return 'rare'; case 'Epic': return 'epic'; default: return 'default'; }
  };
  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle className="flex items-center justify-between">
            <span>{collectible.name}</span>
            <Badge variant={getRarityVariant(collectible.rarity)}>{collectible.rarity}</Badge>
          </DialogTitle>
          <DialogDescription>{collectible.location}</DialogDescription>
        </DialogHeader>
        <div className="space-y-4">
          <Image src={collectible.imageUrl} alt={collectible.name} width={400} height={200} className="w-full h-48 object-cover rounded-lg" unoptimized />
          <p className="text-sm text-muted-foreground">{collectible.description}</p>
          <Button className="w-full" variant={isCollected ? 'secondary' : 'sfPrimary'} onClick={isCollected ? onClose : onCollect} disabled={isCollected}>
            {isCollected ? 'Already Collected!' : 'Collect This Item'}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
ENDOFFILE

echo "✅ Part 3B: Header and modal created. Continuing with map-view..."