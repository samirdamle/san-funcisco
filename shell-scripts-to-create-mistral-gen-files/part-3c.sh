#!/bin/bash
set -e
echo "🗺️ Creating map-view component..."

cat > components/map-view.tsx << 'ENDOFFILE'
'use client';
import { useState, useEffect, useCallback } from 'react';
import { GoogleMap, Marker, useLoadScript } from '@react-google-maps/api';
import { Collectible, SAN_FRANCISCO_COLLECTIBLES } from '@/lib/data';
import { useUserData } from '@/lib/use-user-data';
import { useToast } from '@/components/ui/use-toast';
import { CollectibleModal } from '@/components/collectible-modal';
const MAP_CONTAINER_STYLE = { width: '100%', height: 'calc(100vh - 64px)' };
const MAP_CENTER = { lat: 37.7749, lng: -122.4194 };
const MAP_ZOOM = 13;
export function MapView() {
  const { userData, collectCollectible, isCollectibleCollected } = useUserData();
  const { success } = useToast();
  const [selectedCollectible, setSelectedCollectible] = useState<Collectible | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const { isLoaded, loadError } = useLoadScript({ googleMapsApiKey: process.env.NEXT_PUBLIC_GOOGLE_MAPS_KEY || '', libraries: ['places'] });
  const handleMarkerClick = useCallback((collectible: Collectible) => { setSelectedCollectible(collectible); setIsModalOpen(true); }, []);
  const handleCollect = useCallback(() => {
    if (selectedCollectible) {
      collectCollectible(selectedCollectible.id);
      success({ title: 'Collectible Collected!', description: `You collected ${selectedCollectible.name}` });
      setIsModalOpen(false); setSelectedCollectible(null);
    }
  }, [selectedCollectible, collectCollectible, success]);
  const handleCloseModal = useCallback(() => { setIsModalOpen(false); setSelectedCollectible(null); }, []);
  const getMarkerIcon = (collectible: Collectible) => {
    const isCollected = isCollectibleCollected(collectible.id);
    if (isCollected) {
      return { url: 'data:image/svg+xml;charset=UTF-8,<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"%234ECDC4\"><path d=\"M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z\"/></svg>', scaledSize: new window.google.maps.Size(30, 30) };
    }
    switch (collectible.rarity) {
      case 'Epic': return { url: 'data:image/svg+xml;charset=UTF-8,<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"%239B59B6\"><path d=\"M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z\"/></svg>', scaledSize: new window.google.maps.Size(30, 30) };
      case 'Rare': return { url: 'data:image/svg+xml;charset=UTF-8,<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"%233498DB\"><path d=\"M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z\"/></svg>', scaledSize: new window.google.maps.Size(30, 30) };
      default: return { url: 'data:image/svg+xml;charset=UTF-8,<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"%2395A5A6\"><path d=\"M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z\"/></svg>', scaledSize: new window.google.maps.Size(30, 30) };
    }
  };
  if (loadError) return <div className="flex flex-col items-center justify-center h-[calc(100vh-64px)]"><p className="text-destructive">Error loading Google Maps</p><p className="text-sm text-muted-foreground">Please ensure you have a valid Google Maps API key</p></div>;
  if (!isLoaded) return <div className="flex flex-col items-center justify-center h-[calc(100vh-64px)]"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-sfPrimary"></div><p className="mt-4 text-muted-foreground">Loading map...</p></div>;
  return (
    <>
      <GoogleMap mapContainerStyle={MAP_CONTAINER_STYLE} center={MAP_CENTER} zoom={MAP_ZOOM} options={{ disableDefaultUI: false, gestureHandling: 'greedy', styles: [{ featureType: 'poi', stylers: [{ visibility: 'off' }] }] }}>
        {SAN_FRANCISCO_COLLECTIBLES.map((collectible) => (
          <Marker key={collectible.id} position={{ lat: collectible.lat, lng: collectible.lng }} onClick={() => handleMarkerClick(collectible)} icon={getMarkerIcon(collectible)} title={collectible.name} />
        ))}
      </GoogleMap>
      {selectedCollectible && (
        <CollectibleModal collectible={selectedCollectible} isOpen={isModalOpen} onClose={handleCloseModal} onCollect={handleCollect} isCollected={isCollectibleCollected(selectedCollectible.id)} />
      )}
      <div className="absolute bottom-4 left-4 bg-background/90 backdrop-blur p-4 rounded-lg shadow-lg">
        <p className="text-sm font-medium">Collected: {userData.totalCollected}/{SAN_FRANCISCO_COLLECTIBLES.length}</p>
        <p className="text-xs text-muted-foreground">Click on markers to collect items</p>
      </div>
    </>
  );
}
ENDOFFILE

echo "📚 Creating data and hook files..."
cat > lib/data.ts << 'ENDOFFILE'
export interface Collectible { id: string; name: string; description: string; location: string; lat: number; lng: number; rarity: 'Common' | 'Rare' | 'Epic'; imageUrl: string; collected: boolean; }
export interface Reward { id: string; name: string; description: string; vendor: string; requiredCollectibles: string[]; imageUrl: string; unlocked: boolean; claimed: boolean; }
export interface UserData { userId: string; username: string; collectedCollectibles: Set<string>; unlockedRewards: Set<string>; claimedRewards: Set<string>; totalCollected: number; }
export const SAN_FRANCISCO_COLLECTIBLES: Collectible[] = [
  { id: 'ggb', name: 'Golden Gate Bridge', description: 'Iconic suspension bridge', location: 'Golden Gate Bridge', lat: 37.8199, lng: -122.4783, rarity: 'Epic', imageUrl: 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=200&h=200&fit=crop', collected: false },
  { id: 'alcatraz', name: 'Alcatraz Island', description: 'Former federal prison', location: 'Alcatraz Island', lat: 37.8267, lng: -122.423, rarity: 'Epic', imageUrl: 'https://images.unsplash.com/photo-1508931733121-44a3bcb4d426?w=200&h=200&fit=crop', collected: false },
  { id: 'twin-peaks', name: 'Twin Peaks', description: 'Stunning 360-degree views', location: 'Twin Peaks', lat: 37.7548, lng: -122.4467, rarity: 'Rare', imageUrl: 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?w=200&h=200&fit=crop', collected: false },
  { id: 'lombard', name: 'Lombard Street', description: 'Most crooked street', location: 'Lombard Street', lat: 37.8021, lng: -122.4188, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1504851149312-7a075b496cc7?w=200&h=200&fit=crop', collected: false },
  { id: 'fishermans-wharf', name: 'Fishermans Wharf', description: 'Historic waterfront', location: 'Fishermans Wharf', lat: 37.8081, lng: -122.4175, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1505873242700-f289a29e1e0f?w=200&h=200&fit=crop', collected: false },
  { id: 'pier-39', name: 'Pier 39', description: 'Popular tourist attraction', location: 'Pier 39', lat: 37.8086, lng: -122.4098, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'coit-tower', name: 'Coit Tower', description: 'Landmark tower', location: 'Coit Tower', lat: 37.8025, lng: -122.4058, rarity: 'Rare', imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=200&h=200&fit=crop', collected: false },
  { id: 'chinatown', name: 'Chinatown', description: 'Oldest Chinatown in North America', location: 'Chinatown', lat: 37.7955, lng: -122.4064, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1505664115139-da322097977a?w=200&h=200&fit=crop', collected: false },
  { id: 'north-beach', name: 'North Beach', description: 'Little Italy neighborhood', location: 'North Beach', lat: 37.7994, lng: -122.406, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'union-square', name: 'Union Square', description: 'Central plaza', location: 'Union Square', lat: 37.7879, lng: -122.4075, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'cable-car', name: 'Cable Car Museum', description: 'Historic cable car museum', location: 'Cable Car Museum', lat: 37.7956, lng: -122.4014, rarity: 'Rare', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'painted-ladies', name: 'Painted Ladies', description: 'Colorful Victorian houses', location: 'Painted Ladies', lat: 37.7898, lng: -122.4372, rarity: 'Epic', imageUrl: 'https://images.unsplash.com/photo-1501183638710-841dd1904471?w=200&h=200&fit=crop', collected: false },
  { id: 'gg-park', name: 'Golden Gate Park', description: 'Large urban park', location: 'Golden Gate Park', lat: 37.7694, lng: -122.4862, rarity: 'Rare', imageUrl: 'https://images.unsplash.com/photo-1505664115139-da322097977a?w=200&h=200&fit=crop', collected: false },
  { id: 'academy-of-sciences', name: 'California Academy of Sciences', description: 'Natural history museum', location: 'California Academy of Sciences', lat: 37.7700, lng: -122.4662, rarity: 'Rare', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'de-young', name: 'de Young Museum', description: 'Fine arts museum', location: 'de Young Museum', lat: 37.7703, lng: -122.4686, rarity: 'Rare', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'japanese-tea-garden', name: 'Japanese Tea Garden', description: 'Traditional Japanese garden', location: 'Japanese Tea Garden', lat: 37.7701, lng: -122.4706, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'ferry-building', name: 'Ferry Building', description: 'Historic ferry terminal', location: 'Ferry Building', lat: 37.7953, lng: -122.3942, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'exploratorium', name: 'Exploratorium', description: 'Interactive science museum', location: 'Exploratorium', lat: 37.8017, lng: -122.3975, rarity: 'Rare', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'mission-dolores', name: 'Mission Dolores', description: 'Oldest building in SF', location: 'Mission Dolores', lat: 37.7599, lng: -122.4271, rarity: 'Rare', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'castro', name: 'Castro District', description: 'Historic LGBTQ neighborhood', location: 'Castro District', lat: 37.7624, lng: -122.4348, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false },
  { id: 'haight-ashbury', name: 'Haight-Ashbury', description: '1960s hippie counterculture center', location: 'Haight-Ashbury', lat: 37.7700, lng: -122.4456, rarity: 'Common', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', collected: false }
];
export const SAN_FRANCISCO_REWARDS: Reward[] = [
  { id: 'free-coffee', name: 'Free Coffee', description: 'Get a free coffee at our cafe when you collect 5 collectibles', vendor: 'Blue Bottle Coffee', requiredCollectibles: ['ggb', 'alcatraz', 'twin-peaks', 'lombard', 'fishermans-wharf'], imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200&h=200&fit=crop', unlocked: false, claimed: false },
  { id: 'free-snack', name: 'Free Snack', description: 'Get a free snack at our bakery when you collect 3 collectibles', vendor: 'Boudin Bakery', requiredCollectibles: ['pier-39', 'coit-tower', 'chinatown'], imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&h=200&fit=crop', unlocked: false, claimed: false },
  { id: 'free-magnet', name: 'Free Souvenir Magnet', description: 'Get a free San Francisco magnet when you collect 8 collectibles', vendor: 'SF Gift Shop', requiredCollectibles: ['ggb', 'alcatraz', 'twin-peaks', 'painted-ladies', 'gg-park', 'academy-of-sciences', 'de-young', 'japanese-tea-garden'], imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', unlocked: false, claimed: false },
  { id: 'discount-meal', name: '10% Off Meal', description: 'Get 10% off your meal at our restaurant when you collect 10 collectibles', vendor: 'Scomas Restaurant', requiredCollectibles: ['ggb', 'alcatraz', 'twin-peaks', 'lombard', 'fishermans-wharf', 'pier-39', 'coit-tower', 'chinatown', 'north-beach', 'union-square'], imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&h=200&fit=crop', unlocked: false, claimed: false },
  { id: 'free-ride', name: 'Free Cable Car Ride', description: 'Get a free cable car ride when you collect all 20 collectibles', vendor: 'SF Cable Car System', requiredCollectibles: SAN_FRANCISCO_COLLECTIBLES.map(c => c.id), imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&h=200&fit=crop', unlocked: false, claimed: false }
];
export const DEFAULT_USER_DATA: UserData = { userId: 'demo-001', username: 'Jim Jones', collectedCollectibles: new Set(), unlockedRewards: new Set(), claimedRewards: new Set(), totalCollected: 0 };
ENDOFFILE

cat > lib/use-user-data.ts << 'ENDOFFILE'
'use client';
import { useState, useEffect } from 'react';
import { UserData, DEFAULT_USER_DATA, SAN_FRANCISCO_COLLECTIBLES, SAN_FRANCISCO_REWARDS } from './data';
export function useUserData() {
  const STORAGE_KEY = 'san-funcisco-user-data';
  const [userData, setUserData] = useState<UserData>(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) return JSON.parse(saved);
    }
    return DEFAULT_USER_DATA;
  });
  useEffect(() => {
    if (typeof window !== 'undefined') localStorage.setItem(STORAGE_KEY, JSON.stringify(userData));
  }, [userData]);
  const collectCollectible = (collectibleId: string) => {
    setUserData(prev => {
      const newCollected = new Set(prev.collectedCollectibles);
      newCollected.add(collectibleId);
      const newUnlocked = new Set(prev.unlockedRewards);
      SAN_FRANCISCO_REWARDS.forEach(reward => {
        if (!prev.unlockedRewards.has(reward.id)) {
          const hasAllRequired = reward.requiredCollectibles.every(id => newCollected.has(id));
          if (hasAllRequired) newUnlocked.add(reward.id);
        }
      });
      return { ...prev, collectedCollectibles: newCollected, unlockedRewards: newUnlocked, totalCollected: newCollected.size };
    });
  };
  const claimReward = (rewardId: string) => {
    setUserData(prev => {
      const newClaimed = new Set(prev.claimedRewards);
      newClaimed.add(rewardId);
      return { ...prev, claimedRewards: newClaimed };
    });
  };
  const isCollectibleCollected = (collectibleId: string) => userData.collectedCollectibles.has(collectibleId);
  const isRewardUnlocked = (rewardId: string) => userData.unlockedRewards.has(rewardId);
  const isRewardClaimed = (rewardId: string) => userData.claimedRewards.has(rewardId);
  const resetProgress = () => setUserData(DEFAULT_USER_DATA);
  return { userData, collectCollectible, claimReward, isCollectibleCollected, isRewardUnlocked, isRewardClaimed, resetProgress };
}
ENDOFFILE

echo "📚 Creating album-view and rewards-view..."
cat > components/album-view.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > components/rewards-view.tsx << 'ENDOFFILE'
'use client';
import Image from 'next/image';
import { SAN_FRANCISCO_REWARDS, SAN_FRANCISCO_COLLECTIBLES } from '@/lib/data';
import { useUserData } from '@/lib/use-user-data';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
export function RewardsView() {
  const { userData, claimReward, isRewardUnlocked, isRewardClaimed } = useUserData();
  const getRewardProgress = (reward: any) => {
    const required = reward.requiredCollectibles.length;
    const collected = reward.requiredCollectibles.filter((id: string) => userData.collectedCollectibles.has(id)).length;
    return { collected, required };
  };
  return (
    <div className="container mx-auto p-4">
      <h1 className="text-3xl font-bold mb-6 bg-gradient-to-r from-sfPrimary to-sfSecondary bg-clip-text text-transparent">Rewards</h1>
      <p className="text-muted-foreground mb-6">Earn rewards from local vendors by collecting collectibles!</p>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {SAN_FRANCISCO_REWARDS.map((reward) => {
          const isUnlocked = isRewardUnlocked(reward.id);
          const isClaimed = isRewardClaimed(reward.id);
          const progress = getRewardProgress(reward);
          return (
            <Card key={reward.id} className={`transition-all ${isClaimed ? 'opacity-50 border-muted' : isUnlocked ? 'border-sfPrimary' : 'border-muted'}`}>
              <CardHeader>
                <div className="flex justify-between items-start">
                  <div>
                    <CardTitle>{reward.name}</CardTitle>
                    <CardDescription className="mt-1">{reward.vendor}</CardDescription>
                  </div>
                  {isClaimed && <Badge variant="secondary">Claimed</Badge>}
                  {isUnlocked && !isClaimed && <Badge className="bg-sfPrimary">Available!</Badge>}
                </div>
              </CardHeader>
              <CardContent>
                <Image src={reward.imageUrl} alt={reward.name} width={300} height={200} className="w-full h-40 object-cover rounded-md mb-4" unoptimized />
                <p className="text-sm text-muted-foreground mb-4">{reward.description}</p>
                <div className="mb-4">
                  <p className="text-sm font-medium">Progress: {progress.collected}/{progress.required} collectibles</p>
                  <div className="w-full bg-gray-200 rounded-full h-2 mt-1">
                    <div className="bg-sfPrimary h-2 rounded-full" style={{ width: `${(progress.collected / progress.required) * 100}%` }}></div>
                  </div>
                </div>
                {isUnlocked && !isClaimed && <Button className="w-full" variant="sfPrimary" onClick={() => claimReward(reward.id)}>Claim Reward</Button>}
                {!isUnlocked && <Button className="w-full" variant="secondary" disabled>Collect {progress.required - progress.collected} more items</Button>}
              </CardContent>
            </Card>
          );
        })}
      </div>
      <div className="mt-8 p-6 bg-muted/50 rounded-lg">
        <h2 className="text-xl font-semibold mb-2">How to Claim Rewards</h2>
        <p className="text-muted-foreground">Visit the vendor location and show them your collected items in the app to redeem your reward!</p>
      </div>
    </div>
  );
}
ENDOFFILE

echo ""
echo "🎉 ============================================"
echo "✅ ALL FILES CREATED SUCCESSFULLY!"
echo "🎉 ============================================"
echo ""
echo "📁 Files created in: $(pwd)"
echo ""
echo "🚀 Next steps:"
echo ""
echo "  1. npm install"
echo "  2. Create .env.local file with your Google Maps API key:"
echo "     NEXT_PUBLIC_GOOGLE_MAPS_KEY=your_api_key_here"
echo "  3. npm run dev"
echo "  4. Open http://localhost:3000 in your browser"
echo ""
echo "✨ Built with Next.js 14, shadcn/ui, Tailwind CSS, and TypeScript"