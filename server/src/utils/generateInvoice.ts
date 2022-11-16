import easyinvoice from 'easyinvoice';
import fs from 'fs';



export default async (data: any) => {
    const result = await easyinvoice.createInvoice(data);
    await fs.writeFileSync("public/invoice.pdf", result.pdf, 'base64')
    return true
}
