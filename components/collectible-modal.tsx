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
