'use client';

import { useState, useEffect, useCallback } from 'react';
import { 
  UserData, 
  DEFAULT_USER_DATA, 
  SAN_FRANCISCO_COLLECTIBLES, 
  SAN_FRANCISCO_REWARDS 
} from './data';

const STORAGE_KEY = 'san-funcisco-user-data';

function deserializeSets(data: any): UserData {
  return {
    ...data,
    collectedCollectibles: new Set(data.collectedCollectibles || []),
    unlockedRewards: new Set(data.unlockedRewards || []),
    claimedRewards: new Set(data.claimedRewards || []),
  };
}

export function useUserData(): {
  userData: UserData;
  collectCollectible: (id: string) => void;
  claimReward: (id: string) => void;
  isCollectibleCollected: (id: string) => boolean;
  isRewardUnlocked: (id: string) => boolean;
  isRewardClaimed: (id: string) => boolean;
  resetProgress: () => void;
} {
  const [userData, setUserData] = useState<UserData>(() => {
    if (typeof window === 'undefined') return DEFAULT_USER_DATA;
    const saved = localStorage.getItem(STORAGE_KEY);
    if (!saved) return DEFAULT_USER_DATA;
    try {
      const parsed = JSON.parse(saved);
      return deserializeSets(parsed);
    } catch {
      return DEFAULT_USER_DATA;
    }
  });

  useEffect(() => {
    if (typeof window !== 'undefined') {
      localStorage.setItem(STORAGE_KEY, JSON.stringify({
        ...userData,
        collectedCollectibles: Array.from(userData.collectedCollectibles),
        unlockedRewards: Array.from(userData.unlockedRewards),
        claimedRewards: Array.from(userData.claimedRewards),
      }));
    }
  }, [userData]);

  const collectCollectible = useCallback((collectibleId: string) => {
    setUserData(prev => {
      const newCollected = new Set(prev.collectedCollectibles);
      newCollected.add(collectibleId);

      const newUnlocked = new Set(prev.unlockedRewards);
      SAN_FRANCISCO_REWARDS.forEach(reward => {
        if (!newUnlocked.has(reward.id)) {
          const hasAll = reward.requiredCollectibles.every(id => newCollected.has(id));
          if (hasAll) newUnlocked.add(reward.id);
        }
      });

      return {
        ...prev,
        collectedCollectibles: newCollected,
        unlockedRewards: newUnlocked,
        totalCollected: newCollected.size,
      };
    });
  }, []);

  const claimReward = useCallback((rewardId: string) => {
    setUserData(prev => ({
      ...prev,
      claimedRewards: new Set(prev.claimedRewards).add(rewardId),
    }));
  }, []);

  const isCollectibleCollected = useCallback((collectibleId: string) => {
    return userData.collectedCollectibles.has(collectibleId);
  }, [userData.collectedCollectibles]);

  const isRewardUnlocked = useCallback((rewardId: string) => {
    return userData.unlockedRewards.has(rewardId);
  }, [userData.unlockedRewards]);

  const isRewardClaimed = useCallback((rewardId: string) => {
    return userData.claimedRewards.has(rewardId);
  }, [userData.claimedRewards]);

  const resetProgress = useCallback(() => {
    setUserData(DEFAULT_USER_DATA);
  }, []);

  return {
    userData,
    collectCollectible,
    claimReward,
    isCollectibleCollected,
    isRewardUnlocked,
    isRewardClaimed,
    resetProgress,
  };
}
