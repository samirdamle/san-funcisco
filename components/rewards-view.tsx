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
