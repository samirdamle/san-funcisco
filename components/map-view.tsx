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
