export interface Collectible {
  id: string;
  name: string;
  description: string;
  location: string;
  lat: number;
  lng: number;
  rarity: 'Common' | 'Rare' | 'Epic';
  imageUrl: string;
  collected: boolean;
}

export interface Reward {
  id: string;
  name: string;
  description: string;
  vendor: string;
  requiredCollectibles: string[];
  imageUrl: string;
  unlocked: boolean;
  claimed: boolean;
}

export interface UserData {
  userId: string;
  username: string;
  collectedCollectibles: Set<string>;
  unlockedRewards: Set<string>;
  claimedRewards: Set<string>;
  totalCollected: number;
}

export const SAN_FRANCISCO_COLLECTIBLES: Collectible[] = [
  {
    id: 'ggb',
    name: 'Golden Gate Bridge',
    description: 'Iconic suspension bridge spanning the Golden Gate strait',
    location: 'Golden Gate Bridge',
    lat: 37.8199,
    lng: -122.4783,
    rarity: 'Epic',
    imageUrl: 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'alcatraz',
    name: 'Alcatraz Island',
    description: 'Former federal prison on an island in San Francisco Bay',
    location: 'Alcatraz Island',
    lat: 37.8267,
    lng: -122.423,
    rarity: 'Epic',
    imageUrl: 'https://images.unsplash.com/photo-1518117901826-8597f7350046?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'twin-peaks',
    name: 'Twin Peaks',
    description: 'Two peaks with stunning 360-degree views of San Francisco',
    location: 'Twin Peaks',
    lat: 37.7548,
    lng: -122.4467,
    rarity: 'Rare',
    imageUrl: 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'lombard',
    name: 'Lombard Street',
    description: 'The most crooked street in the world with 8 hairpin turns',
    location: 'Lombard Street',
    lat: 37.8021,
    lng: -122.4188,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1504851149312-7a075b496cc7?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'fishermans-wharf',
    name: 'Fishermans Wharf',
    description: 'Historic waterfront area with seafood restaurants and shops',
    location: 'Fishermans Wharf',
    lat: 37.8081,
    lng: -122.4175,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'pier-39',
    name: 'Pier 39',
    description: 'Popular tourist attraction with shops, restaurants, and sea lions',
    location: 'Pier 39',
    lat: 37.8086,
    lng: -122.4098,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1551733998-153c08042556?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'coit-tower',
    name: 'Coit Tower',
    description: 'Landmark tower in the Telegraph Hill neighborhood',
    location: 'Coit Tower',
    lat: 37.8025,
    lng: -122.4058,
    rarity: 'Rare',
    imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'chinatown',
    name: 'Chinatown',
    description: 'The oldest Chinatown in North America',
    location: 'Chinatown',
    lat: 37.7955,
    lng: -122.4064,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'north-beach',
    name: 'North Beach',
    description: 'Neighborhood known as Little Italy with great cafes and restaurants',
    location: 'North Beach',
    lat: 37.7994,
    lng: -122.406,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'union-square',
    name: 'Union Square',
    description: 'Central plaza and shopping district in downtown San Francisco',
    location: 'Union Square',
    lat: 37.7879,
    lng: -122.4075,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'cable-car',
    name: 'Cable Car Museum',
    description: 'Museum showcasing the historic cable car system',
    location: 'Cable Car Museum',
    lat: 37.7956,
    lng: -122.4014,
    rarity: 'Rare',
    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'painted-ladies',
    name: 'Painted Ladies',
    description: 'Row of colorful Victorian houses at Alamo Square',
    location: 'Painted Ladies',
    lat: 37.7898,
    lng: -122.4372,
    rarity: 'Epic',
    imageUrl: 'https://images.unsplash.com/photo-1501183638710-841dd1904471?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'gg-park',
    name: 'Golden Gate Park',
    description: 'Large urban park larger than Central Park',
    location: 'Golden Gate Park',
    lat: 37.7694,
    lng: -122.4862,
    rarity: 'Rare',
    imageUrl: 'https://images.unsplash.com/photo-1577985051167-5d5534aa2341?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'academy-of-sciences',
    name: 'California Academy of Sciences',
    description: 'Natural history museum with aquarium, planetarium, and rainforest',
    location: 'California Academy of Sciences',
    lat: 37.7700,
    lng: -122.4662,
    rarity: 'Rare',
    imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'de-young',
    name: 'de Young Museum',
    description: 'Fine arts museum in Golden Gate Park',
    location: 'de Young Museum',
    lat: 37.7703,
    lng: -122.4686,
    rarity: 'Rare',
    imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'japanese-tea-garden',
    name: 'Japanese Tea Garden',
    description: 'Traditional Japanese garden with tea house',
    location: 'Japanese Tea Garden',
    lat: 37.7701,
    lng: -122.4706,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'ferry-building',
    name: 'Ferry Building',
    description: 'Historic ferry terminal with marketplace',
    location: 'Ferry Building',
    lat: 37.7953,
    lng: -122.3942,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'exploratorium',
    name: 'Exploratorium',
    description: 'Interactive science museum at Pier 15',
    location: 'Exploratorium',
    lat: 37.8017,
    lng: -122.3975,
    rarity: 'Rare',
    imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'mission-dolores',
    name: 'Mission Dolores',
    description: 'Oldest building in San Francisco, founded in 1776',
    location: 'Mission Dolores',
    lat: 37.7599,
    lng: -122.4271,
    rarity: 'Rare',
    imageUrl: 'https://images.unsplash.com/photo-1605701149383-48d484363546?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'castro',
    name: 'Castro District',
    description: 'Historic LGBTQ neighborhood with the Castro Theatre',
    location: 'Castro District',
    lat: 37.7624,
    lng: -122.4348,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
  {
    id: 'haight-ashbury',
    name: 'Haight-Ashbury',
    description: 'Historic center of the 1960s hippie counterculture',
    location: 'Haight-Ashbury',
    lat: 37.7700,
    lng: -122.4456,
    rarity: 'Common',
    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop&q=80',
    collected: false,
  },
];

export const SAN_FRANCISCO_REWARDS: Reward[] = [
  {
    id: 'free-coffee',
    name: 'Free Coffee',
    description: 'Get a free coffee at our cafe when you collect 5 collectibles',
    vendor: 'Blue Bottle Coffee',
    requiredCollectibles: ['ggb', 'alcatraz', 'twin-peaks', 'lombard', 'fishermans-wharf'],
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&h=300&fit=crop&q=80',
    unlocked: false,
    claimed: false,
  },
  {
    id: 'free-snack',
    name: 'Free Snack',
    description: 'Get a free snack at our bakery when you collect 3 collectibles',
    vendor: 'Boudin Bakery',
    requiredCollectibles: ['pier-39', 'coit-tower', 'chinatown'],
    imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop&q=80',
    unlocked: false,
    claimed: false,
  },
  {
    id: 'free-magnet',
    name: 'Free Souvenir Magnet',
    description: 'Get a free San Francisco magnet when you collect 8 collectibles',
    vendor: 'SF Gift Shop',
    requiredCollectibles: ['ggb', 'alcatraz', 'twin-peaks', 'painted-ladies', 'gg-park', 'academy-of-sciences', 'de-young', 'japanese-tea-garden'],
    imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop&q=80',
    unlocked: false,
    claimed: false,
  },
  {
    id: 'discount-meal',
    name: '10% Off Meal',
    description: 'Get 10% off your meal at our restaurant when you collect 10 collectibles',
    vendor: 'Scomas Restaurant',
    requiredCollectibles: ['ggb', 'alcatraz', 'twin-peaks', 'lombard', 'fishermans-wharf', 'pier-39', 'coit-tower', 'chinatown', 'north-beach', 'union-square'],
    imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=300&fit=crop&q=80',
    unlocked: false,
    claimed: false,
  },
  {
    id: 'free-ride',
    name: 'Free Cable Car Ride',
    description: 'Get a free cable car ride when you collect all 20 collectibles',
    vendor: 'SF Cable Car System',
    requiredCollectibles: SAN_FRANCISCO_COLLECTIBLES.map(c => c.id),
    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop&q=80',
    unlocked: false,
    claimed: false,
  },
];

export const DEFAULT_USER_DATA: UserData = {
  userId: 'demo-001',
  username: 'Jim Jones',
  collectedCollectibles: new Set(),
  unlockedRewards: new Set(),
  claimedRewards: new Set(),
  totalCollected: 0,
};
