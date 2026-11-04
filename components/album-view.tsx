'use client';
import { useState } from 'react';
import Image from 'next/image';
import { SAN_FRANCISCO_COLLECTIBLES } from '@/lib/data';
import { useUserData } from '@/lib/use-user-data';
import { CollectibleModal } from '@/components/collectible-modal';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
export function AlbumView() {
  const { isCollectibleCollected } = useUserData();
  const [selectedCollectible, setSelectedCollectible] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const handleCollectibleClick = (collectible) => { setSelectedCollectible(collectible); setIsModalOpen(true); };
  const handleCloseModal = () => { setIsModalOpen(false); setSelectedCollectible(null); };
  const collectiblesByRarity = {
    Epic: SAN_FRANCISCO_COLLECTIBLES.filter(c => c.rarity === 'Epic'),
    Rare: SAN_FRANCISCO_COLLECTIBLES.filter(c => c.rarity === 'Rare'),
    Common: SAN_FRANCISCO_COLLECTIBLES.filter(c => c.rarity === 'Common'),
  };
  return (
    <div className="container mx-auto p-4">
      <h1 className="text-3xl font-bold mb-6 bg-gradient-to-r from-sfPrimary to-sfSecondary bg-clip-text text-transparent">Collectibles Album</h1>
      <Tabs defaultValue="all" className="w-full">
        <TabsList className="grid w-full grid-cols-4 lg:grid-cols-4 mb-6">
          <TabsTrigger value="all">All Collectibles</TabsTrigger>
          <TabsTrigger value="epic">Epic ({collectiblesByRarity.Epic.length})</TabsTrigger>
          <TabsTrigger value="rare">Rare ({collectiblesByRarity.Rare.length})</TabsTrigger>
          <TabsTrigger value="common">Common ({collectiblesByRarity.Common.length})</TabsTrigger>
        </TabsList>
        <TabsContent value="all">
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {SAN_FRANCISCO_COLLECTIBLES.map((collectible) => {
              const isCollected = isCollectibleCollected(collectible.id);
              return (
                <Card key={collectible.id} className={`cursor-pointer transition-all hover:shadow-lg ${isCollected ? 'border-sfPrimary' : 'border-muted opacity-60'}`} onClick={() => handleCollectibleClick(collectible)}>
                  <CardHeader className="p-3">
                    <div className="flex justify-between items-center">
                      <CardTitle className="text-sm">{collectible.name}</CardTitle>
                      <Badge variant={collectible.rarity.toLowerCase() as any}>{collectible.rarity}</Badge>
                    </div>
                  </CardHeader>
                  <CardContent className="p-3">
                    <Image src={collectible.imageUrl} alt={collectible.name} width={200} height={150} className="w-full h-32 object-cover rounded-md" unoptimized />
                    <p className="text-xs text-muted-foreground mt-2 line-clamp-2">{collectible.location}</p>
                    {isCollected && <div className="absolute top-2 right-2"><span className="text-green-500">✓</span></div>}
                  </CardContent>
                </Card>
              );
            })}
          </div>
        </TabsContent>
        {(['Epic', 'Rare', 'Common'] as const).map((rarity) => (
          <TabsContent key={rarity} value={rarity.toLowerCase()}>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {collectiblesByRarity[rarity].map((collectible) => {
                const isCollected = isCollectibleCollected(collectible.id);
                return (
                  <Card key={collectible.id} className={`cursor-pointer transition-all hover:shadow-lg ${isCollected ? 'border-sfPrimary' : 'border-muted opacity-60'}`} onClick={() => handleCollectibleClick(collectible)}>
                    <CardHeader className="p-3"><CardTitle className="text-sm">{collectible.name}</CardTitle></CardHeader>
                    <CardContent className="p-3">
                      <Image src={collectible.imageUrl} alt={collectible.name} width={200} height={150} className="w-full h-32 object-cover rounded-md" unoptimized />
                      <p className="text-xs text-muted-foreground mt-2 line-clamp-2">{collectible.location}</p>
                      {isCollected && <div className="absolute top-2 right-2"><span className="text-green-500">✓</span></div>}
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </TabsContent>
        ))}
      </Tabs>
      {selectedCollectible && (
        <CollectibleModal collectible={selectedCollectible} isOpen={isModalOpen} onClose={handleCloseModal} onCollect={() => {}} isCollected={isCollectibleCollected(selectedCollectible.id)} />
      )}
    </div>
  );
}
