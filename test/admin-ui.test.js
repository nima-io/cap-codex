const test = require('node:test');
const assert = require('node:assert/strict');
const cds = require('@sap/cds');
const { chromium } = require('playwright');

test('Admin UI renders list report', async () => {
  const srv = await cds.test(__dirname + '/..');
  const browser = await chromium.launch({ args: ['--ignore-certificate-errors'] });
  const context = await browser.newContext({ locale: 'en-US' });
  const page = await context.newPage();
  await page.goto(`${srv.url}/admin/webapp/index.html`, { waitUntil: 'networkidle' });
  // allow UI to settle
  await page.waitForTimeout(1000);
  const text = await page.evaluate(() => document.body.innerText);
  assert.match(text, /Add columns to see the\s+content/);
  await browser.close();
  await srv.server.close();
});
