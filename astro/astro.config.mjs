import { defineConfig } from 'astro/config'
import mdx from '@astrojs/mdx'
import sitemap from '@astrojs/sitemap'
import tailwind from '@astrojs/tailwind'
import { remarkReadingTime } from './src/utils/readTime.ts'
import react from '@astrojs/react';
import partytown from '@astrojs/partytown'


// https://astro.build/config
export default defineConfig({
    site: 'https://lexdsolutions.com',
    markdown: {
        remarkPlugins: [remarkReadingTime],
        drafts: true,
        shikiConfig: {
            theme: 'material-theme-palenight',
            wrap: true
        }
    },
    integrations: [
        mdx({
            syntaxHighlight: 'shiki',
            shikiConfig: {
                theme: 'material-theme-palenight',
                wrap: true
            },
            drafts: true
		}),
        sitemap(),
        tailwind(),
        react(),
        partytown({
            config: {
              forward: ["dataLayer.push"],
            },
        }),
    ],
    server: {
        host: '0.0.0.0'
    },
})