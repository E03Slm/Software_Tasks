const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'https://jxhitikmhurzybgksmup.supabase.co';
const SUPABASE_KEY = 'sb_publishable_mwGPrhzvT6mIXDAOBqi5xQ_BDp1K-ut';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

const drugs = [
  {
    name: 'Dopamine',
    concentration: 400,
    concentration_unit: 'mg/250mL',
    default_rate: 5.0,
    soft_limit_high: 15.0,
    hard_limit_high: 20.0,
    kvo_enabled: true,
    kvo_rate: 1.0,
    Is_Deleted: false
  },
  {
    name: 'Norepinephrine',
    concentration: 4,
    concentration_unit: 'mg/250mL',
    default_rate: 2.0,
    soft_limit_high: 10.0,
    hard_limit_high: 15.0,
    kvo_enabled: false,
    Is_Deleted: false
  },
  {
    name: 'Insulin',
    concentration: 100,
    concentration_unit: 'Units/100mL',
    default_rate: 1.0,
    soft_limit_high: 5.0,
    hard_limit_high: 10.0,
    kvo_enabled: true,
    kvo_rate: 0.5,
    Is_Deleted: false
  }
];

async function seed() {
  console.log('🚀 Starting database seed...');

  // Note: This script assumes you have already created the 'drug' table in the Supabase SQL Editor.
  // See DESIGN.md or the SQL provided in the conversation for the schema.

  const { data, error } = await supabase
    .from('drug')
    .upsert(drugs, { onConflict: 'name' });

  if (error) {
    console.error('❌ Error seeding drugs:', error.message);
    if (error.message.includes('404')) {
      console.log('💡 Tip: Make sure you created the "drug" table in the Supabase Dashboard first.');
    }
  } else {
    console.log('✅ Successfully seeded ' + drugs.length + ' pharmaceutical protocols.');
  }
}

seed();
