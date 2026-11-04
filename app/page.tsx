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
