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
