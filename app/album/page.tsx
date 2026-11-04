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
