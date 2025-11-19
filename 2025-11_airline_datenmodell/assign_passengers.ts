import { prisma } from "./repository/db.ts";

// Assign each passenger to one random flight.
async function main() {
  console.log('Starting assignment of passengers to flights...');
  const flights = await prisma.flight.findMany({ select: { id: true } });
  const passengers = await prisma.passenger.findMany({ select: { id: true } });
  if (flights.length === 0) {
    console.error('No flights found — aborting');
    await prisma.$disconnect();
    return;
  }
  console.log(`Found ${passengers.length} passengers and ${flights.length} flights.`);

  const batchSize = 500;
  let assigned = 0;
  for (let i = 0; i < passengers.length; i += batchSize) {
    const batch = passengers.slice(i, i + batchSize);
    const tx = batch.map(p => {
      const flightId = flights[Math.floor(Math.random() * flights.length)].id;
      return prisma.passenger.update({ where: { id: p.id }, data: { flights: { connect: { id: flightId } } } });
    });
    await prisma.$transaction(tx);
    assigned += batch.length;
    console.log(`Assigned ${assigned}/${passengers.length} passengers...`);
  }

  console.log('Assignment complete.');
  const countRes: any = await prisma.$queryRaw`SELECT count(*) as c FROM _FlightToPassenger`;
  console.log('Total links in _FlightToPassenger:', countRes[0]?.c ?? countRes?.c ?? countRes);
  await prisma.$disconnect();
}

main().catch(async (e) => {
  console.error('Error during assignment:', e);
  try { await prisma.$disconnect(); } catch {}
  Deno.exit(1);
});
