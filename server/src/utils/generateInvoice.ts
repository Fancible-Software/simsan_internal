import axios from "axios"


export default async (options: any) => {
    return new Promise((resolve, reject) => {

        const url = 'https://marswellfoods.com/api/generate/invoice';


        const config = {
            headers: {
                'easyinvoice-source': 'npm'
            }
        };
        axios.post(url, options, config).then((response) => {
            // console.log(response.data.data)
            if (response.data.success) {

                resolve(response.data.data);
            } else {
                resolve(false)
            }

        }).catch((error) => {
            console.log(error.response.data);

            reject(false);
        })
    })

}
