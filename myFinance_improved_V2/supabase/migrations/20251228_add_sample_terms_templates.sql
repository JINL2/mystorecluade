-- Add sample Terms & Conditions templates for test company
-- company_id: b5e3f93b-34ee-4269-b3d1-6e52e76dec71

INSERT INTO trade_terms_templates (company_id, template_name, content, is_default, sort_order) VALUES

-- Standard Export Terms (Default)
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'Standard Export Terms',
'1. QUALITY: Goods shall conform to the specifications stated in this Proforma Invoice.

2. PACKING: Goods shall be packed in export standard packing suitable for ocean/air transport.

3. SHIPMENT: Partial shipment and transshipment are allowed unless otherwise specified.

4. INSURANCE: Insurance to be covered by Buyer unless otherwise agreed.

5. FORCE MAJEURE: Neither party shall be liable for any failure or delay in performing their obligations due to causes beyond their reasonable control.

6. ARBITRATION: Any dispute arising from this contract shall be settled by arbitration in accordance with the rules of ICC.

7. GOVERNING LAW: This contract shall be governed by and construed in accordance with the laws of the Republic of Korea.',
true, 1),

-- L/C Payment Terms
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'L/C Payment Terms',
'1. PAYMENT: By Irrevocable Letter of Credit at sight/usance as specified.

2. L/C REQUIREMENTS:
   - L/C must be issued by a first-class international bank
   - L/C must be received at least 30 days before shipment date
   - All banking charges outside Korea are for Buyer''s account

3. DOCUMENTS REQUIRED:
   - Commercial Invoice (3 originals)
   - Packing List (3 originals)
   - Bill of Lading (3/3 originals)
   - Certificate of Origin
   - Insurance Policy (if CIF)

4. QUALITY: As per specifications in this Proforma Invoice.

5. PACKING: Standard export packing.

6. VALIDITY: This offer is valid for 30 days from the date hereof.',
false, 2),

-- FOB Terms
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'FOB Terms',
'1. TERMS: FOB (Free On Board) as per Incoterms 2020.

2. SELLER''S OBLIGATIONS:
   - Deliver goods on board the vessel at the named port of shipment
   - Clear goods for export
   - Provide commercial invoice and transport document

3. BUYER''S OBLIGATIONS:
   - Nominate the vessel and notify seller
   - Bear all costs and risks from the point goods are on board
   - Arrange and pay for ocean freight and insurance

4. RISK TRANSFER: Risk passes from Seller to Buyer when goods are on board the vessel.

5. PACKING: Export standard packing included in price.

6. PAYMENT: As specified in Payment Terms section.',
false, 3),

-- CIF Terms
('b5e3f93b-34ee-4269-b3d1-6e52e76dec71', 'CIF Terms',
'1. TERMS: CIF (Cost, Insurance and Freight) as per Incoterms 2020.

2. SELLER''S OBLIGATIONS:
   - Deliver goods on board the vessel
   - Pay freight to destination port
   - Obtain minimum insurance coverage (110% of invoice value)
   - Clear goods for export

3. BUYER''S OBLIGATIONS:
   - Bear all risks from the point goods are on board at origin
   - Clear goods for import
   - Pay all costs after arrival at destination

4. INSURANCE: Institute Cargo Clauses (C) minimum, unless otherwise specified.

5. DOCUMENTS: Full set of clean on board B/L, Insurance Policy, Commercial Invoice, Packing List.

6. PAYMENT: As specified in Payment Terms section.',
false, 4);
