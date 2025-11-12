import { PrismaClient } from "./prisma/client/client.ts";

const prisma = new PrismaClient();

const TARGETS = {
  passengers: 20000,
  planes: 250,
  airports: 100,
  flights: 2500,
};

const POLL_INTERVAL_MS = 5000; // 5s
const MAX_IDLE_MINUTES = 120; // safety timeout

async function main() {
  console.log('Monitor started — polling every', POLL_INTERVAL_MS / 1000, 's');
  let lastProgressAt = Date.now();
  let lastCounts = { passengers: 0, planes: 0, airports: 0, flights: 0 };

  while (true) {
    const [passengers, planes, airports, flights] = await Promise.all([
      prisma.passenger.count(),
      prisma.plane.count(),
      prisma.airport.count(),
      prisma.flight.count(),
    ]);

    console.log(new Date().toISOString(), `counts -> passengers:${passengers}, planes:${planes}, airports:${airports}, flights:${flights}`);

    // progress check
    if (passengers !== lastCounts.passengers || planes !== lastCounts.planes || airports !== lastCounts.airports || flights !== lastCounts.flights) {
      lastProgressAt = Date.now();
      lastCounts = { passengers, planes, airports, flights };
    }

    // check targets
    if (passengers >= TARGETS.passengers && planes >= TARGETS.planes && airports >= TARGETS.airports && flights >= TARGETS.flights) {
      console.log('All targets reached. Monitor exiting.');
      break;
    }

    // timeout if idle
    if (Date.now() - lastProgressAt > MAX_IDLE_MINUTES * 60 * 1000) {
      console.warn('No progress for', MAX_IDLE_MINUTES, 'minutes — exiting monitor.');
      break;
    }

    await new Promise((r) => setTimeout(r, POLL_INTERVAL_MS));
  }

  await prisma.$disconnect();
}

main().catch((e) => { console.error('Monitor failed:', e); Deno.exit(1); });
