const { test } = require('@playwright/test');

test('capture love page errors', async ({ page }) => {
  page.on('console', msg => console.log('BROWSER_CONSOLE:', msg.type(), msg.text()));
  page.on('pageerror', err => console.log('PAGEERROR:', err.toString()));
  page.on('requestfailed', req => console.log('REQUESTFAILED:', req.url(), req.failure()?.errorText));

  const response = await page.goto('http://localhost:3000', { waitUntil: 'load', timeout: 30000 });
  console.log('STATUS', response && response.status());

  await page.waitForTimeout(8000);
});
