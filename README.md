# Arczhar & Shyleah Wedding Website

A photo-free, mobile-first digital wedding invitation built with Vue 3 and Vite.

## Features

- Elegant opening invitation screen
- Live countdown to July 25, 2026 at 2:00 PM
- Wedding details and Google Maps button
- Entourage and principal sponsors
- Dress-code palette
- RSVP form with July 20, 2026 deadline
- Supabase-ready storage
- Free Vercel deployment

## Run locally

1. Install Node.js 20 or later.
2. Open a terminal inside this project folder.
3. Run:

```bash
npm install
npm run dev
```

## Connect Supabase

1. Create a free Supabase project.
2. Open **SQL Editor** and run `supabase.sql`.
3. Copy `.env.example` to `.env`.
4. Add your Supabase project URL and anon key.
5. Restart the development server.

Without Supabase, the website runs in demo mode and stores RSVP responses only in the current browser.

## Deploy free on Vercel

1. Push this folder to a GitHub repository.
2. Import the repository in Vercel.
3. Add these environment variables in Vercel:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. Deploy. Vercel will provide a free `.vercel.app` address.

## Important

Test the final public URL and RSVP submission before creating the QR code for the printed invitation.
