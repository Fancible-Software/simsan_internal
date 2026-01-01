import rateLimit from "express-rate-limit";
import { ExpressMiddlewareInterface, Middleware } from "routing-controllers";
import { Request, Response, NextFunction } from "express";

// Create rate limiter at module initialization (not on each request)
const contactRateLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // Limit each IP to 5 requests per windowMs
    standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
    legacyHeaders: false, // Disable the `X-RateLimit-*` headers
    handler: (_req: Request, res: Response) => {
        res.status(429).json({
            status: false,
            message: "Too many requests from this IP, please try again later.",
        });
    },
});

@Middleware({ type: "before" })
export class RateLimiterMiddleware implements ExpressMiddlewareInterface {
    use(request: Request, response: Response, next: NextFunction): void {
        contactRateLimiter(request, response, next);
    }
}

