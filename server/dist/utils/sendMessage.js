"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const nodemailer_1 = __importDefault(require("nodemailer"));
const logger_1 = __importDefault(require("./logger"));
const transport = nodemailer_1.default.createTransport({
    port: 587,
    host: "smtp-mail.outlook.com",
    secure: false,
    tls: {
        ciphers: "SSLv3",
    },
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PWD,
    },
});
exports.default = async (opts) => {
    var _a;
    try {
        const resp = await transport.sendMail(opts);
        logger_1.default.info("mail resp: " + JSON.stringify(resp, null, 1));
        if (resp && ((_a = resp.rejected) === null || _a === void 0 ? void 0 : _a.length)) {
            logger_1.default.error(resp);
        }
    }
    catch (error) {
        console.error(error);
    }
};
//# sourceMappingURL=sendMessage.js.map