import { prisma } from "./repository/db.ts";

async function main() {
    try {
        const countRes: any = await prisma.$queryRaw`SELECT count(*) as c FROM _FlightToPassenger`;
        console.log('join count:', countRes[0]?.c ?? countRes?.c ?? countRes);
        const sample: any = await prisma.$queryRaw`SELECT * FROM _FlightToPassenger LIMIT 10`;
        console.log('sample rows:', sample);
    } catch (e) {
        console.error('error querying join table:', e);
    } finally {
        await prisma.$disconnect();
    }
}

main();
