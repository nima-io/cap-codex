import test from 'node:test';
import assert from 'node:assert/strict';
import cds from '@sap/cds';
import fs from 'node:fs';
import path from 'node:path';

const { GET, POST } = cds.test(__dirname + '/..');

test('contact action is localized', async () => {
  let res = await GET('/odata/v4/admin/Customers?$top=1');
  assert.equal(res.status, 200);
  const id = res.data.value[0].ID;

  res = await POST(`/odata/v4/admin/Customers(ID=${id})/contact`, { subject: 'Hi', message: 'Test' }, { headers: { 'Accept-Language': 'de' } });
  assert.equal(res.status, 200);
  assert.equal(res.data.value, 'Nachricht gesendet');

  res = await POST(`/odata/v4/admin/Customers(ID=${id})/contact`, { subject: 'Hi', message: 'Test' }, { headers: { 'Accept-Language': 'en' } });
  assert.equal(res.status, 200);
  assert.equal(res.data.value, 'Message sent');
});

test('Fiori app bundles include German translations', () => {
  const i18nDir = path.join(__dirname, '../app/project1/webapp/i18n');
  const readProps = (file: string) =>
    Object.fromEntries(
      fs
        .readFileSync(file, 'utf-8')
        .split(/\r?\n/)
        .filter((l) => l && !l.startsWith('#'))
        .map((l) => {
          const idx = l.indexOf('=');
          return [l.slice(0, idx), l.slice(idx + 1)];
        })
    );
  const en = readProps(path.join(i18nDir, 'i18n.properties'));
  const de = readProps(path.join(i18nDir, 'i18n_de.properties'));
  assert.equal(en.appTitle, 'Book management');
  assert.equal(de.appTitle, 'Buchverwaltung');
  assert.equal(de.appDescription, 'Eine SAP Fiori Anwendung.');
});
