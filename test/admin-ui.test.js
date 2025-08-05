const test = require('node:test');
const assert = require('node:assert/strict');
const cds = require('@sap/cds');
const { chromium } = require('playwright');

const fs = require('node:fs');

test('Admin UI renders authors list with data', async () => {
  const srv = await cds.test(__dirname + '/..');
  const browser = await chromium.launch({ args: ['--ignore-certificate-errors'] });
  const context = await browser.newContext({ locale: 'en-US' });
  const page = await context.newPage();
  await page.goto(`${srv.url}/admin/webapp/index.html`, { waitUntil: 'networkidle' });

  // allow UI to settle
  await page.waitForTimeout(1000);

  // ensure data is loaded
  const goButton = page.getByRole('button', { name: 'Go' });
  await goButton.click({ force: true });

  // ensure folder for screenshots exists
  fs.mkdirSync('test-results', { recursive: true });

  // wait for author data to appear
  await page.waitForSelector('text=Primo Levi', { timeout: 10000 });
  await page.screenshot({ path: 'test-results/admin-authors-list.png', fullPage: true });

  const text = await page.locator('body').innerText();
  assert.match(text, /Primo Levi/);

  await browser.close();
  await srv.server.close();
});
