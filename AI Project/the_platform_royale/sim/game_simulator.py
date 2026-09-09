import random
import time

class PlayerAgent:
    def __init__(self, id_num):
        self.id = f"Player_{id_num}"
        self.hp = 100.0
        self.hunger = 100.0
        self.floor = random.randint(1, 120)
        self.weapon = random.choice(["Sword", "Axe", "Bow", "Dagger", "Hammer"])
        self.element = random.choice(["Fire", "Ice", "Lightning", "Poison", "Shadow"])
        self.relic = random.choice(["Phoenix Heart", "Void Eye", "Titan Bone", None])
        self.kills = 0
        self.is_alive = True

    def get_hunger_stage(self):
        if self.hunger >= 70.0:
            return "HIGH", 1.0
        elif self.hunger >= 40.0:
            return "MEDIUM", 1.15
        elif self.hunger >= 15.0:
            return "LOW", 1.40
        else:
            return "RAGE", 2.00

    def tick(self, current_floors):
        if not self.is_alive:
            return
        # Hunger decay
        self.hunger = max(0.0, self.hunger - random.uniform(0.5, 2.0))
        if self.hunger == 0:
            self.hp -= 2.0
            if self.hp <= 0:
                self.is_alive = False

        # Floor hazard check
        if self.floor > current_floors:
            # Player trapped in collapsed floor
            self.is_alive = False

def calculate_floor_scaling(alive_count):
    if alive_count >= 70:
        return int(85 + (alive_count - 70) * (120 - 85) / 30)
    elif alive_count >= 40:
        return int(50 + (alive_count - 40) * (85 - 50) / 30)
    elif alive_count >= 10:
        return int(15 + (alive_count - 10) * (50 - 15) / 30)
    else:
        return max(5, int(alive_count * 1.5))

def run_battle_royale_simulation():
    print("=" * 60)
    print("      THE PLATFORM ROYALE - BATTLE ROYALE SIMULATOR")
    print("=" * 60)
    
    players = [PlayerAgent(i + 1) for i in range(100)]
    alive = len(players)
    current_floors = 120
    round_num = 1

    print(f"Match Initialized: 100 Players | Initial Tower Height: {current_floors} Floors\n")

    while alive > 1 and round_num <= 10:
        print(f"--- ROUND {round_num} START --- (Alive Players: {alive} | Active Floors: {current_floors})")
        
        # Simulate combat clashes per floor
        floor_groups = {}
        for p in players:
            if p.is_alive:
                floor_groups.setdefault(p.floor, []).append(p)
        
        for floor_id, occupants in floor_groups.items():
            if len(occupants) >= 2:
                # Combat event
                p1, p2 = random.sample(occupants, 2)
                stage1, mult1 = p1.get_hunger_stage()
                stage2, mult2 = p2.get_hunger_stage()
                
                dmg1 = random.uniform(15, 25) * mult1
                dmg2 = random.uniform(15, 25) * mult2
                
                p2.hp -= dmg1
                p1.hp -= dmg2
                
                if p2.hp <= 0:
                    if p2.relic == "Phoenix Heart":
                        p2.hp = 50.0
                        p2.relic = None
                    else:
                        p2.is_alive = False
                        p1.kills += 1
                        
                if p1.hp <= 0:
                    if p1.relic == "Phoenix Heart":
                        p1.hp = 50.0
                        p1.relic = None
                    else:
                        p1.is_alive = False
                        p2.kills += 1

        # Tick hunger & floor boundaries
        for p in players:
            p.tick(current_floors)
            
        alive = sum(1 for p in players if p.is_alive)
        
        # Calculate floor reduction for next round
        target_floors = calculate_floor_scaling(alive)
        floors_removed = current_floors - target_floors
        print(f"Round {round_num} Complete -> Alive: {alive} | Removing {floors_removed} Excess Floors -> Target: {target_floors} Floors")
        current_floors = target_floors
        
        # Re-assign remaining players to new floor limits
        for p in players:
            if p.is_alive:
                p.floor = random.randint(1, max(1, current_floors))
                
        round_num += 1

    survivors = [p for p in players if p.is_alive]
    print("\n" + "=" * 60)
    if survivors:
        winner = max(survivors, key=lambda x: x.kills)
        print(f"VICTORY ROYALE! Winner: {winner.id} | Kills: {winner.kills} | Weapon: {winner.element} {winner.weapon}")
    else:
        print("NO SURVIVORS - Tower Collapsed Completely!")
    print("=" * 60)

if __name__ == "__main__":
    run_battle_royale_simulation()
