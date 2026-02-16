use serde::{Deserialize, Serialize};
use std::time::Duration;
use tokio::time::sleep;

#[derive(Serialize, Deserialize, Debug)]
struct MatchStats {
    fixture_id: u32,
    possession_home: u8,
    possession_away: u8,
    shots_on_target_home: u8,
    shots_on_target_away: u8,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("Sports Analytics Microservice (Rust) starting...");

    loop {
        // Mock stats processing
        let stats = MatchStats {
            fixture_id: 123,
            possession_home: 55,
            possession_away: 45,
            shots_on_target_home: 6,
            shots_on_target_away: 2,
        };

        let win_prob_home = calculate_win_probability(&stats);
        println!("Match ID: {} | Home Win Prob: {}%", stats.fixture_id, win_prob_home);

        sleep(Duration::from_secs(10)).await;
    }
}

fn calculate_win_probability(stats: &MatchStats) -> f32 {
    let base = stats.possession_home as f32 * 0.4;
    let shots = stats.shots_on_target_home as f32 * 10.0;
    (base + shots).min(99.0)
}
