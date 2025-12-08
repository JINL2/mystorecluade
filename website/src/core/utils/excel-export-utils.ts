/**
 * Excel Import/Export Utilities
 * Handles ExcelJS library loading and Excel file generation/parsing
 *
 * Features:
 * - Lazy loading of ExcelJS library (4.4.0)
 * - Modern File System Access API with fallback
 * - Inventory data export with styling
 * - Inventory data import with validation
 */

// ExcelJS types (will be available after loading)
declare global {
  interface Window {
    ExcelJS?: any;
  }
}

/**
 * Excel Export Manager
 * Singleton pattern for ExcelJS library management
 */
class ExcelExportManager {
  private excelJSLoaded = false;
  private excelJSLoading: Promise<boolean> | null = null;

  /**
   * Load ExcelJS library from CDN (lazy loading)
   * @returns Promise that resolves when library is loaded
   */
  async loadExcelJS(): Promise<boolean> {
    // If already loaded, return immediately
    if (this.excelJSLoaded) {
      return true;
    }

    // If currently loading, wait for the existing promise
    if (this.excelJSLoading) {
      return this.excelJSLoading;
    }

    // Start loading
    this.excelJSLoading = new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = 'https://cdn.jsdelivr.net/npm/exceljs@4.4.0/dist/exceljs.min.js';
      script.async = true;

      script.onload = () => {
        this.excelJSLoaded = true;
        this.excelJSLoading = null;
        console.log('✅ ExcelJS loaded successfully');
        resolve(true);
      };

      script.onerror = () => {
        this.excelJSLoading = null;
        console.error('❌ Failed to load ExcelJS');
        reject(new Error('Failed to load ExcelJS library'));
      };

      document.head.appendChild(script);
    });

    return this.excelJSLoading;
  }

  /**
   * Export inventory data to Excel file
   * @param products - Array of inventory items
   * @param storeName - Store name for filename
   * @param currencyCode - Currency code for column headers
   * @returns Promise that resolves when export is complete
   */
  async exportInventoryToExcel(
    products: any[],
    storeName: string = 'AllStores',
    currencyCode: string = 'VND'
  ): Promise<void> {
    // Load ExcelJS library
    await this.loadExcelJS();

    const ExcelJS = window.ExcelJS;
    if (!ExcelJS) {
      throw new Error('ExcelJS library not loaded');
    }

    // Create a new workbook
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('Inventory');

    // Define columns with headers and widths
    worksheet.columns = [
      { header: 'Product Code (SKU)', key: 'sku', width: 18 },
      { header: 'Barcode', key: 'barcode', width: 15 },
      { header: 'Product Name', key: 'product_name', width: 30 },
      { header: 'Category', key: 'category', width: 20 },
      { header: 'Brand', key: 'brand', width: 20 },
      { header: 'Unit', key: 'unit', width: 10 },
      { header: `Cost Price (${currencyCode})`, key: 'cost_price', width: 15 },
      { header: `Selling Price (${currencyCode})`, key: 'selling_price', width: 15 },
      { header: 'Current Stock', key: 'current_stock', width: 15 },
      { header: 'Status', key: 'status', width: 12 },
      { header: 'image1', key: 'image1', width: 50 },
      { header: 'image2', key: 'image2', width: 50 },
      { header: 'image3', key: 'image3', width: 50 },
    ];

    // Add product data
    products.forEach((product) => {
      // Extract image URLs (up to 3 images)
      const imageUrls = product.imageUrls || [];

      worksheet.addRow({
        sku: product.productCode || product.sku || '',
        barcode: product.barcode || '',
        product_name: product.productName || '',
        category: product.categoryName || '',
        brand: product.brandName || '',
        unit: product.unit || 'piece',
        cost_price: product.costPrice || 0,
        selling_price: product.unitPrice || 0,
        current_stock: product.currentStock || 0,
        status: product.currentStock === 0 ? 'OUT OF STOCK' : product.currentStock <= 5 ? 'LOW STOCK' : 'IN STOCK',
        image1: imageUrls[0] || '',
        image2: imageUrls[1] || '',
        image3: imageUrls[2] || '',
      });
    });

    // Style the header row
    const headerRow = worksheet.getRow(1);
    headerRow.font = {
      name: 'Arial',
      size: 11,
      bold: true,
      color: { argb: 'FFFFFFFF' }, // White text
    };
    headerRow.fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FF4472C4' }, // Blue background
    };
    headerRow.alignment = {
      vertical: 'middle',
      horizontal: 'center',
      wrapText: false,
    };
    headerRow.height = 25;

    // Add borders to header cells (include empty cells for image columns)
    headerRow.eachCell({ includeEmpty: true }, (cell: any) => {
      cell.border = {
        top: { style: 'thin', color: { argb: 'FF000000' } },
        left: { style: 'thin', color: { argb: 'FF000000' } },
        bottom: { style: 'thin', color: { argb: 'FF000000' } },
        right: { style: 'thin', color: { argb: 'FF000000' } },
      };
    });

    // Add light borders to data cells (include empty cells for image columns)
    worksheet.eachRow((row: any, rowNumber: number) => {
      if (rowNumber > 1) {
        row.eachCell({ includeEmpty: true }, (cell: any) => {
          cell.border = {
            top: { style: 'thin', color: { argb: 'FFD3D3D3' } },
            left: { style: 'thin', color: { argb: 'FFD3D3D3' } },
            bottom: { style: 'thin', color: { argb: 'FFD3D3D3' } },
            right: { style: 'thin', color: { argb: 'FFD3D3D3' } },
          };
          // Center align numeric columns
          const columnKey = worksheet.getColumn(cell.col).key;
          if (['cost_price', 'selling_price', 'current_stock'].includes(columnKey)) {
            cell.alignment = { horizontal: 'center', vertical: 'middle' };
          }
        });
      }
    });

    // Freeze the header row
    worksheet.views = [{ state: 'frozen', ySplit: 1 }];

    // Generate filename with current date
    const today = new Date();
    const dateStr =
      today.getFullYear() +
      String(today.getMonth() + 1).padStart(2, '0') +
      String(today.getDate()).padStart(2, '0');
    const filename = `Inventory_${storeName}_${dateStr}.xlsx`;

    // Generate Excel file buffer
    const buffer = await workbook.xlsx.writeBuffer();
    const blob = new Blob([buffer], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    });

    // Download the file
    await this.downloadExcelFile(blob, filename, products.length);
  }

  /**
   * Download Excel file using File System Access API with fallback
   * @param blob - Excel file blob
   * @param filename - Suggested filename
   * @param productCount - Number of products exported
   */
  private async downloadExcelFile(
    blob: Blob,
    filename: string,
    productCount: number
  ): Promise<void> {
    let downloadHandled = false;

    // Check if File System Access API is supported
    const isFileSystemAPISupported =
      'showSaveFilePicker' in window &&
      window.isSecureContext &&
      !window.location.protocol.includes('file:');

    if (isFileSystemAPISupported) {
      try {
        // Modern browsers with File System Access API support
        const handle = await (window as any).showSaveFilePicker({
          suggestedName: filename,
          types: [
            {
              description: 'Excel Files',
              accept: {
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ['.xlsx'],
              },
            },
          ],
          excludeAcceptAllOption: true,
        });

        // Write the file
        const writable = await handle.createWritable();
        await writable.write(blob);
        await writable.close();

        downloadHandled = true;

        console.log(`✅ Export successful: ${productCount} products exported to ${filename}`);
      } catch (err: any) {
        if (err.name === 'AbortError') {
          // User cancelled - throw error to prevent success notification
          console.log('ℹ️ Export cancelled by user');
          throw new Error('Export cancelled by user');
        } else if (err.name === 'SecurityError' || err.name === 'NotAllowedError') {
          // Permission or security issue - use fallback
          downloadHandled = false;
        } else {
          // Other error - use fallback
          downloadHandled = false;
        }
      }
    }

    // Use fallback if File System API not supported or failed
    if (!downloadHandled) {
      this.fallbackExcelDownload(blob, filename);
    }
  }

  /**
   * Fallback download method for browsers without File System Access API
   * @param blob - Excel file blob
   * @param filename - Suggested filename
   */
  private fallbackExcelDownload(blob: Blob, filename: string): void {
    try {
      // Create download link and trigger save dialog
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = filename;
      link.style.display = 'none';

      // Append to body and trigger download
      document.body.appendChild(link);
      link.click();

      // Clean up immediately
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);

      console.log(`✅ Export successful (fallback): File saved to default downloads folder`);
    } catch (error) {
      console.error('❌ Fallback download error:', error);
      throw error; // Re-throw to be caught by the main error handler
    }
  }

  /**
   * Parse Excel file and extract product data
   * @param file - Excel file to parse
   * @returns Promise with array of product data
   */
  async parseInventoryExcel(file: File): Promise<any[]> {
    // Load ExcelJS library
    await this.loadExcelJS();

    const ExcelJS = window.ExcelJS;
    if (!ExcelJS) {
      throw new Error('ExcelJS library not loaded');
    }

    // Parse Excel file
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(await file.arrayBuffer());

    const worksheet = workbook.getWorksheet(1); // First worksheet
    const products: any[] = [];

    // Extract data (skip header row)
    worksheet.eachRow((row: any, rowNumber: number) => {
      if (rowNumber === 1) return; // Skip header row

      // Get cell values by column number
      const productData = {
        sku: row.getCell(1).value || null, // Column A - SKU
        barcode: row.getCell(2).value || null, // Column B - Barcode
        product_name: row.getCell(3).value || '', // Column C - Product Name
        category: row.getCell(4).value || null, // Column D - Category
        brand: row.getCell(5).value || null, // Column E - Brand
        unit: row.getCell(6).value || 'piece', // Column F - Unit
        cost_price: parseFloat(row.getCell(7).value) || 0, // Column G - Cost Price
        selling_price: parseFloat(row.getCell(8).value) || 0, // Column H - Selling Price
        current_stock: parseFloat(row.getCell(9).value) || 0, // Column I - Current Stock
        status: row.getCell(10).value || 'Active', // Column J - Status
        image_urls: null as any, // Will be populated below from columns K, L, M
      };

      // Data validation and cleaning
      if (productData.product_name) {
        // Convert all string fields to proper strings
        if (productData.sku !== null) productData.sku = String(productData.sku).trim();
        if (productData.barcode !== null) productData.barcode = String(productData.barcode).trim();
        if (productData.product_name) productData.product_name = String(productData.product_name).trim();
        if (productData.category !== null) productData.category = String(productData.category).trim();
        if (productData.brand !== null) productData.brand = String(productData.brand).trim();
        if (productData.unit) productData.unit = String(productData.unit).toLowerCase().trim();
        if (productData.status) productData.status = String(productData.status).trim();

        // Convert empty strings to null
        if (productData.sku === '') productData.sku = null;
        if (productData.barcode === '') productData.barcode = null;
        if (productData.category === '') productData.category = null;
        if (productData.brand === '') productData.brand = null;

        // Ensure numeric values are numbers
        productData.cost_price = isNaN(productData.cost_price) ? 0 : productData.cost_price;
        productData.selling_price = isNaN(productData.selling_price) ? 0 : productData.selling_price;
        productData.current_stock = isNaN(productData.current_stock) ? 0 : productData.current_stock;

        // Process image URLs from columns K, L, M (image1, image2, image3)
        const imageUrls: string[] = [];
        const image1 = row.getCell(11).value; // Column K - image1
        const image2 = row.getCell(12).value; // Column L - image2
        const image3 = row.getCell(13).value; // Column M - image3

        // Add non-empty image URLs to array
        if (image1 && String(image1).trim() !== '') {
          imageUrls.push(String(image1).trim());
        }
        if (image2 && String(image2).trim() !== '') {
          imageUrls.push(String(image2).trim());
        }
        if (image3 && String(image3).trim() !== '') {
          imageUrls.push(String(image3).trim());
        }

        // Set image_urls array (RPC expects array, not null)
        productData.image_urls = imageUrls;

        products.push(productData);
      }
    });

    return products;
  }
}

// Export singleton instance
export const excelExportManager = new ExcelExportManager();
