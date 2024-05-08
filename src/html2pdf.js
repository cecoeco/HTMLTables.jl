const puppeteer = require("puppeteer");

/**
 * Converts an HTML table to a PDF
 * @param {string} html - HTML table as a string
 * @param {string} pdf - path to PDF
 */
async function html2pdf(html, pdf) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  
  await page.setContent(html, { waitUntil: "networkidle0" });
  await new Promise((resolve) => setTimeout(resolve, 1000));

  const pdfOptions = {
    path: pdf,
    printBackground: true
  };

  await page.pdf(pdfOptions);
  await browser.close();
}
