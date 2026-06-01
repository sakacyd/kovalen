<!DOCTYPE html>

<html lang="id"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Masuk - Kovalen</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "background": "#f8f9fa",
                        "secondary-container": "#febb8d",
                        "on-tertiary-container": "#d7deee",
                        "on-error-container": "#93000a",
                        "surface-container-high": "#e7e8e9",
                        "surface-bright": "#f8f9fa",
                        "error": "#ba1a1a",
                        "outline": "#737686",
                        "secondary-fixed-dim": "#fbb88a",
                        "surface": "#FFFFFF",
                        "error-container": "#ffdad6",
                        "surface-variant": "#e1e3e4",
                        "surface-container-low": "#f3f4f5",
                        "tertiary-container": "#5b626f",
                        "primary-container": "#1a56db",
                        "on-tertiary-fixed-variant": "#404754",
                        "on-secondary-fixed": "#301400",
                        "on-primary-fixed-variant": "#003dab",
                        "primary": "#003fb1",
                        "on-secondary": "#ffffff",
                        "on-surface-variant": "#434654",
                        "surface-container-lowest": "#ffffff",
                        "success": "#059669",
                        "on-primary": "#ffffff",
                        "inverse-primary": "#b5c4ff",
                        "on-secondary-container": "#794924",
                        "tertiary-fixed-dim": "#c0c7d6",
                        "on-primary-container": "#d4dcff",
                        "on-surface": "#191c1d",
                        "outline-variant": "#c3c5d7",
                        "on-tertiary-fixed": "#151c27",
                        "stroke": "#E5E7EB",
                        "primary-fixed": "#dbe1ff",
                        "surface-tint": "#1353d8",
                        "on-secondary-fixed-variant": "#693b18",
                        "on-background": "#191c1d",
                        "surface-container-highest": "#e1e3e4",
                        "surface-dim": "#d9dadb",
                        "on-primary-fixed": "#00174d",
                        "secondary-fixed": "#ffdcc6",
                        "secondary": "#85522d",
                        "surface-container": "#edeeef",
                        "inverse-surface": "#2e3132",
                        "inverse-on-surface": "#f0f1f2",
                        "on-error": "#ffffff",
                        "primary-fixed-dim": "#b5c4ff",
                        "text-primary": "#111827",
                        "tertiary-fixed": "#dce2f3",
                        "tertiary": "#434a57",
                        "on-tertiary": "#ffffff"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "stack-sm": "0.5rem",
                        "stack-lg": "1.5rem",
                        "stack-md": "0.75rem",
                        "gutter-default": "1rem",
                        "margin-main": "1.5rem"
                    },
                    "fontFamily": {
                        "headline-md": ["Inter"],
                        "body-md": ["Inter"],
                        "label-sm": ["Inter"],
                        "body-lg": ["Inter"],
                        "label-md": ["Inter"],
                        "headline-sm": ["Inter"],
                        "headline-lg": ["Inter"]
                    },
                    "fontSize": {
                        "headline-md": ["20px", { "lineHeight": "28px", "letterSpacing": "-0.01em", "fontWeight": "700" }],
                        "body-md": ["14px", { "lineHeight": "20px", "fontWeight": "400" }],
                        "label-sm": ["10px", { "lineHeight": "14px", "fontWeight": "600" }],
                        "body-lg": ["16px", { "lineHeight": "24px", "fontWeight": "400" }],
                        "label-md": ["12px", { "lineHeight": "16px", "letterSpacing": "0.02em", "fontWeight": "500" }],
                        "headline-sm": ["18px", { "lineHeight": "24px", "fontWeight": "600" }],
                        "headline-lg": ["28px", { "lineHeight": "34px", "letterSpacing": "-0.02em", "fontWeight": "700" }]
                    }
                }
            }
        }
    </script>
<style>
        .custom-shadow {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background min-h-screen flex text-on-surface antialiased">
<!-- Split Layout Container -->
<div class="flex w-full min-h-screen">
<!-- Left Side - Visual Anchor (Hidden on smaller screens to prioritize form canvas) -->
<div class="hidden lg:flex lg:w-1/2 relative bg-surface-container-high items-center justify-center overflow-hidden">
<div class="absolute inset-0 z-0">
<img alt="Campus Library Background" class="w-full h-full object-cover opacity-80 mix-blend-multiply" data-alt="A sophisticated and modern university campus library interior, featuring natural sunlight streaming through large geometric windows onto clean wooden desks. The scene represents academic ambition and focus, shot with a high-key, bright light-mode aesthetic. The color palette emphasizes crisp whites, warm wood tones, and subtle hints of primary blue, conveying a reliable and intellectual atmosphere suitable for a higher education matchmaking platform." src="https://lh3.googleusercontent.com/aida-public/AB6AXuACjhAZ4iVBRAZHNYhcQr37Nlu510gHcdgYhpkqi3K2f9_aetfpVCXiytItw6GQtHnFAvgCUWv1YM-h-0B-k6E2kYQXYt4uTHW8O5fya60sntQcT-spA6fntjjTL8gw0hM0yiExFb53rC6SPkzeNn9jYOcXGkIVmjhLADdafHod57oomlU1-_wRWuyAkAWBgcRdcVedBAz1raBPoHEyuqtjGpsQlSQClqyyxq2mgShya3c1HmFoP9tYc-PkkspiZIRwhbWkcyzIsLb9"/>
<!-- Subtle Gradient Overlay -->
<div class="absolute inset-0 bg-gradient-to-tr from-surface/60 via-transparent to-primary/10"></div>
</div>
<div class="relative z-10 max-w-lg p-margin-main text-center">
<div class="bg-surface/80 backdrop-blur-md p-stack-lg rounded-xl custom-shadow border border-stroke/50 inline-block mb-stack-md">
<span class="material-symbols-outlined text-primary text-4xl" style="font-variation-settings: 'FILL' 1;">school</span>
</div>
<h2 class="font-headline-lg text-headline-lg text-on-surface mb-stack-sm">Koneksi Akademik Dimulai Di Sini</h2>
<p class="font-body-lg text-body-lg text-on-surface-variant">Bergabunglah dengan ekosistem perjodohan yang dirancang khusus untuk mahasiswa, mengedepankan ambisi intelektual dan kolaborasi terstruktur.</p>
</div>
</div>
<!-- Right Side - Focused Authentication Canvas -->
<div class="w-full lg:w-1/2 flex items-center justify-center p-margin-main bg-background">
<!-- Auth Card (Level 1 Surface) -->
<div class="w-full max-w-md bg-surface rounded-xl custom-shadow border border-stroke p-stack-lg sm:p-8 flex flex-col space-y-8">
<!-- Header / Brand -->
<div class="text-center space-y-stack-sm">
<h1 class="font-headline-lg text-headline-lg text-primary tracking-tight">Kovalen</h1>
<p class="font-body-md text-body-md text-on-surface-variant">Silakan masuk menggunakan kredensial universitas Anda.</p>
</div>
<!-- Login Form -->
<form class="space-y-stack-lg">
<div class="space-y-stack-sm">
<label class="block font-label-md text-label-md text-on-surface" for="email">Email Institusi</label>
<div class="relative">
<div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
<span class="material-symbols-outlined text-outline text-lg">mail</span>
</div>
<input class="block w-full pl-10 pr-3 py-2 border border-stroke rounded-DEFAULT bg-surface text-text-primary font-body-md text-body-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-colors placeholder-outline" id="email" name="email" placeholder="nama@kampus.ac.id" required="" type="email"/>
</div>
<p class="font-label-sm text-label-sm text-outline flex items-center gap-1 mt-1">
<span class="material-symbols-outlined text-[12px]">info</span>
                            Gunakan email dengan domain .ac.id atau .edu
                        </p>
</div>
<div class="space-y-stack-sm">
<div class="flex justify-between items-center">
<label class="block font-label-md text-label-md text-on-surface" for="password">Kata Sandi</label>
<a class="font-label-md text-label-md text-primary hover:text-surface-tint transition-colors" href="#">Lupa sandi?</a>
</div>
<div class="relative">
<div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
<span class="material-symbols-outlined text-outline text-lg">lock</span>
</div>
<input class="block w-full pl-10 pr-10 py-2 border border-stroke rounded-DEFAULT bg-surface text-text-primary font-body-md text-body-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-colors placeholder-outline" id="password" name="password" placeholder="••••••••" required="" type="password"/>
<button aria-label="Toggle password visibility" class="absolute inset-y-0 right-0 pr-3 flex items-center text-outline hover:text-on-surface transition-colors" type="button">
<span class="material-symbols-outlined text-lg">visibility_off</span>
</button>
</div>
</div>
<!-- Primary Action -->
<button class="w-full flex justify-center items-center gap-2 py-3 px-4 border border-transparent rounded-lg shadow-sm font-label-md text-label-md text-on-primary bg-primary hover:bg-surface-tint focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary active:scale-[0.98] transition-all" type="submit">
                        Masuk
                        <span class="material-symbols-outlined text-sm">login</span>
</button>
</form>
<!-- Footer Links -->
<div class="text-center pt-stack-sm border-t border-stroke">
<p class="font-body-md text-body-md text-on-surface-variant">
                        Belum memiliki profil akademik? 
                        <a class="font-label-md text-label-md text-primary hover:text-surface-tint transition-colors ml-1" href="#">Daftar sekarang</a>
</p>
</div>
</div>
<!-- Minimal Footer across the bottom for credibility -->
<div class="absolute bottom-4 w-full text-center hidden sm:block">
<p class="font-label-sm text-label-sm text-outline">© 2024 Kovalen. Jaringan Akademik Terverifikasi.</p>
</div>
</div>
</div>
</body></html>