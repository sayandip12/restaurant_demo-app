import React from 'react';
import { useLocation } from 'react-router-dom';
import './MandalaBackground.css';

/* =============================================
   Ultra-Dense Intricate Indian Mandala SVG
   Matches the dense gold-on-dark reference with
   12+ concentric rings, zigzag borders, dot 
   arrays, crosshatch fills, and radiating rays.
   ============================================= */
const MandalaSVG = () => {
  const c = (n) => Array.from({ length: n });

  return (
    <svg viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg" className="mandala-svg">
      <g transform="translate(500,500)" fill="none" stroke="currentColor">

        {/* ====== CORE: Solid center + tiny flower ====== */}
        <circle r="6" fill="currentColor" stroke="none" />
        <circle r="10" strokeWidth="2.5" />
        <circle r="14" strokeWidth="1.5" />
        {c(8).map((_, i) => (
          <g key={`c1-${i}`} transform={`rotate(${i * 45})`}>
            <ellipse cx="0" cy="-18" rx="5" ry="9" strokeWidth="2" />
            <circle cx="0" cy="-18" r="2" fill="currentColor" stroke="none" />
          </g>
        ))}

        {/* Ring 1 border */}
        <circle r="28" strokeWidth="2.5" />
        <circle r="31" strokeWidth="1" strokeDasharray="2,2" />
        <circle r="34" strokeWidth="2" />

        {/* Ring 2: 12 teardrops + dots between */}
        {c(12).map((_, i) => (
          <g key={`r2-${i}`} transform={`rotate(${i * 30})`}>
            <path d="M 0 -36 C -8 -46 -10 -56 0 -64 C 10 -56 8 -46 0 -36" strokeWidth="2.2" />
            <path d="M 0 -42 C -4 -48 -5 -54 0 -58 C 5 -54 4 -48 0 -42" strokeWidth="1.5" />
            <circle cx="0" cy="-50" r="2" fill="currentColor" stroke="none" />
          </g>
        ))}
        {c(12).map((_, i) => (
          <g key={`r2d-${i}`} transform={`rotate(${i * 30 + 15})`}>
            <circle cx="0" cy="-50" r="1.8" fill="currentColor" stroke="none" />
            <line x1="0" y1="-36" x2="0" y2="-44" strokeWidth="1.2" />
          </g>
        ))}

        {/* Zigzag border ring */}
        <circle r="68" strokeWidth="2.5" />
        {c(24).map((_, i) => (
          <g key={`z1-${i}`} transform={`rotate(${i * 15})`}>
            <path d="M 0 -70 L 4.5 -76 L 0 -82 L -4.5 -76 Z" strokeWidth="1.5" />
          </g>
        ))}
        <circle r="84" strokeWidth="2" />
        <circle r="87" strokeWidth="1" strokeDasharray="3,2" />

        {/* Ring 3: 16 petals with crosshatch interior */}
        {c(16).map((_, i) => (
          <g key={`r3-${i}`} transform={`rotate(${i * 22.5})`}>
            <path d="M 0 -89 C -14 -102 -18 -120 0 -134 C 18 -120 14 -102 0 -89" strokeWidth="2.5" />
            <path d="M 0 -97 C -8 -106 -10 -118 0 -126 C 10 -118 8 -106 0 -97" strokeWidth="1.8" />
            {/* Crosshatch lines inside petal */}
            <line x1="-5" y1="-106" x2="5" y2="-114" strokeWidth="0.8" />
            <line x1="5" y1="-106" x2="-5" y2="-114" strokeWidth="0.8" />
            <line x1="-4" y1="-114" x2="4" y2="-122" strokeWidth="0.8" />
            <line x1="4" y1="-114" x2="-4" y2="-122" strokeWidth="0.8" />
            <circle cx="0" cy="-112" r="2" fill="currentColor" stroke="none" />
          </g>
        ))}
        {/* Arches between Ring 3 */}
        {c(16).map((_, i) => (
          <g key={`r3a-${i}`} transform={`rotate(${i * 22.5 + 11.25})`}>
            <path d="M -10 -131 Q 0 -144 10 -131" strokeWidth="1.8" />
            <circle cx="0" cy="-138" r="1.5" fill="currentColor" stroke="none" />
          </g>
        ))}

        {/* Dense dot ring */}
        <circle r="138" strokeWidth="2.5" />
        {c(48).map((_, i) => (
          <g key={`d1-${i}`} transform={`rotate(${i * 7.5})`}>
            <circle cx="0" cy="-143" r="1.8" fill="currentColor" stroke="none" />
          </g>
        ))}
        <circle r="148" strokeWidth="2" />

        {/* Ring 4: 24 pointed petals with diamond + spine */}
        {c(24).map((_, i) => (
          <g key={`r4-${i}`} transform={`rotate(${i * 15})`}>
            <path d="M 0 -150 C -14 -164 -18 -184 0 -198 C 18 -184 14 -164 0 -150" strokeWidth="2.5" />
            <path d="M 0 -157 C -8 -166 -10 -180 0 -190 C 10 -180 8 -166 0 -157" strokeWidth="1.5" />
            <line x1="0" y1="-155" x2="0" y2="-192" strokeWidth="1" />
            <path d="M 0 -164 L -4 -174 L 0 -184 L 4 -174 Z" strokeWidth="1.2" />
            <circle cx="0" cy="-174" r="1.5" fill="currentColor" stroke="none" />
          </g>
        ))}
        {/* Tiny buds between Ring 4 */}
        {c(24).map((_, i) => (
          <g key={`r4b-${i}`} transform={`rotate(${i * 15 + 7.5})`}>
            <path d="M 0 -150 C -4 -158 -4 -166 0 -172 C 4 -166 4 -158 0 -150" strokeWidth="1.5" />
            <circle cx="0" cy="-161" r="1.2" fill="currentColor" stroke="none" />
          </g>
        ))}

        {/* Zigzag + dot border */}
        <circle r="202" strokeWidth="3" />
        {c(32).map((_, i) => (
          <g key={`z2-${i}`} transform={`rotate(${i * 11.25})`}>
            <path d="M 0 -204 L 3.5 -210 L 0 -216 L -3.5 -210 Z" strokeWidth="1.2" />
            <circle cx="0" cy="-210" r="1" fill="currentColor" stroke="none" />
          </g>
        ))}
        <circle r="218" strokeWidth="2" />
        <circle r="221" strokeWidth="1.2" strokeDasharray="4,2" />
        <circle r="224" strokeWidth="2.5" />

        {/* Ring 5: 32 ornate leaves with veins */}
        {c(32).map((_, i) => (
          <g key={`r5-${i}`} transform={`rotate(${i * 11.25})`}>
            <path d="M 0 -226 C -18 -244 -22 -268 0 -288 C 22 -268 18 -244 0 -226" strokeWidth="2.5" />
            <path d="M 0 -236 C -10 -248 -13 -264 0 -278 C 13 -264 10 -248 0 -236" strokeWidth="1.5" />
            {/* Leaf veins */}
            <line x1="0" y1="-238" x2="0" y2="-276" strokeWidth="1" />
            <line x1="-6" y1="-254" x2="0" y2="-248" strokeWidth="0.8" />
            <line x1="6" y1="-254" x2="0" y2="-248" strokeWidth="0.8" />
            <line x1="-5" y1="-264" x2="0" y2="-258" strokeWidth="0.8" />
            <line x1="5" y1="-264" x2="0" y2="-258" strokeWidth="0.8" />
            <circle cx="0" cy="-274" r="2" fill="currentColor" stroke="none" />
          </g>
        ))}
        {/* Scalloped arches + dots between Ring 5 */}
        {c(32).map((_, i) => (
          <g key={`r5a-${i}`} transform={`rotate(${i * 11.25 + 5.625})`}>
            <path d="M -8 -285 Q 0 -296 8 -285" strokeWidth="1.8" />
            <circle cx="0" cy="-291" r="1.5" fill="currentColor" stroke="none" />
          </g>
        ))}

        {/* Dense double-ring border with dots */}
        <circle r="292" strokeWidth="3" />
        {c(64).map((_, i) => (
          <g key={`d2-${i}`} transform={`rotate(${i * 5.625})`}>
            <circle cx="0" cy="-296" r="1.3" fill="currentColor" stroke="none" />
          </g>
        ))}
        <circle r="300" strokeWidth="2" />
        <circle r="303" strokeWidth="1" />
        <circle r="306" strokeWidth="2.5" />

        {/* Ring 6: 32 flame petals with crosshatch */}
        {c(32).map((_, i) => (
          <g key={`r6-${i}`} transform={`rotate(${i * 11.25})`}>
            <path d="M 0 -308 C -16 -324 -20 -346 0 -364 C 20 -346 16 -324 0 -308" strokeWidth="2.5" />
            <path d="M 0 -316 C -10 -328 -12 -344 0 -356 C 12 -344 10 -328 0 -316" strokeWidth="1.5" />
            {/* Crosshatch fill */}
            <line x1="-4" y1="-326" x2="4" y2="-334" strokeWidth="0.7" />
            <line x1="4" y1="-326" x2="-4" y2="-334" strokeWidth="0.7" />
            <line x1="-3" y1="-336" x2="3" y2="-344" strokeWidth="0.7" />
            <line x1="3" y1="-336" x2="-3" y2="-344" strokeWidth="0.7" />
            <circle cx="0" cy="-336" r="1.8" fill="currentColor" stroke="none" />
          </g>
        ))}
        {/* Spikes between Ring 6 */}
        {c(32).map((_, i) => (
          <g key={`r6s-${i}`} transform={`rotate(${i * 11.25 + 5.625})`}>
            <line x1="0" y1="-308" x2="0" y2="-332" strokeWidth="1.5" />
            <circle cx="0" cy="-336" r="1.5" fill="currentColor" stroke="none" />
          </g>
        ))}

        {/* Triple border + zigzag */}
        <circle r="368" strokeWidth="3" />
        {c(48).map((_, i) => (
          <g key={`z3-${i}`} transform={`rotate(${i * 7.5})`}>
            <path d="M 0 -370 L 3 -376 L 0 -382 L -3 -376 Z" strokeWidth="1" />
          </g>
        ))}
        <circle r="384" strokeWidth="2" />
        {c(64).map((_, i) => (
          <g key={`d3-${i}`} transform={`rotate(${i * 5.625})`}>
            <circle cx="0" cy="-388" r="1.2" fill="currentColor" stroke="none" />
          </g>
        ))}
        <circle r="392" strokeWidth="2.5" />

        {/* Ring 7: 48 dense outer petals */}
        {c(48).map((_, i) => (
          <g key={`r7-${i}`} transform={`rotate(${i * 7.5})`}>
            <path d="M 0 -394 C -10 -404 -12 -420 0 -432 C 12 -420 10 -404 0 -394" strokeWidth="2.2" />
            <line x1="0" y1="-398" x2="0" y2="-428" strokeWidth="0.8" />
            <circle cx="0" cy="-413" r="1.5" fill="currentColor" stroke="none" />
          </g>
        ))}

        {/* Border */}
        <circle r="436" strokeWidth="3" />
        {c(96).map((_, i) => (
          <g key={`d4-${i}`} transform={`rotate(${i * 3.75})`}>
            <circle cx="0" cy="-440" r="1" fill="currentColor" stroke="none" />
          </g>
        ))}
        <circle r="444" strokeWidth="2" />

        {/* Ring 8: 64 tiny fine petals */}
        {c(64).map((_, i) => (
          <g key={`r8-${i}`} transform={`rotate(${i * 5.625})`}>
            <path d="M 0 -446 C -6 -452 -7 -462 0 -470 C 7 -462 6 -452 0 -446" strokeWidth="1.8" />
            <circle cx="0" cy="-458" r="1" fill="currentColor" stroke="none" />
          </g>
        ))}

        {/* Outer border ring */}
        <circle r="474" strokeWidth="3" />
        <circle r="477" strokeWidth="1" strokeDasharray="2,2" />
        <circle r="480" strokeWidth="2.5" />

        {/* Ring 9: Radiating rays + dot bursts */}
        {c(64).map((_, i) => (
          <g key={`ray-${i}`} transform={`rotate(${i * 5.625})`}>
            <line x1="0" y1="-482" x2="0" y2="-498" strokeWidth="1.5" />
            <circle cx="0" cy="-492" r="1.2" fill="currentColor" stroke="none" />
          </g>
        ))}
        {/* Larger rays every 8th */}
        {c(16).map((_, i) => (
          <g key={`rayL-${i}`} transform={`rotate(${i * 22.5})`}>
            <line x1="0" y1="-482" x2="0" y2="-510" strokeWidth="2" />
            <circle cx="0" cy="-505" r="2" fill="currentColor" stroke="none" />
            <circle cx="0" cy="-514" r="1.5" fill="currentColor" stroke="none" />
          </g>
        ))}
        {/* Medium rays every 4th */}
        {c(32).map((_, i) => (
          <g key={`rayM-${i}`} transform={`rotate(${i * 11.25 + 5.625})`}>
            <line x1="0" y1="-482" x2="0" y2="-504" strokeWidth="1.2" />
            <circle cx="0" cy="-500" r="1.3" fill="currentColor" stroke="none" />
          </g>
        ))}

        {/* Outermost dot halo */}
        {c(96).map((_, i) => (
          <g key={`halo-${i}`} transform={`rotate(${i * 3.75})`}>
            <circle cx="0" cy="-520" r={i % 3 === 0 ? 2 : 1} fill="currentColor" stroke="none" />
          </g>
        ))}
        {c(48).map((_, i) => (
          <g key={`halo2-${i}`} transform={`rotate(${i * 7.5 + 3.75})`}>
            <circle cx="0" cy="-530" r={i % 4 === 0 ? 1.8 : 0.8} fill="currentColor" stroke="none" />
          </g>
        ))}

      </g>
    </svg>
  );
};

const MandalaBackground = () => {
  const location = useLocation();
  const path = location.pathname;

  let pageClass = 'page-home';
  if (path.includes('/menu')) pageClass = 'page-menu';
  else if (path.includes('/contact')) pageClass = 'page-contact';
  else if (path.includes('/track')) pageClass = 'page-order';
  else if (path.includes('/admin') || path.includes('/profile')) pageClass = 'page-dashboard';

  return (
    <div className={`mandala-bg-container ${pageClass}`} aria-hidden="true">
      <div className="bg-mandala bg-mandala-top-left"><MandalaSVG /></div>
      <div className="bg-mandala bg-mandala-top-right"><MandalaSVG /></div>
      <div className="bg-mandala bg-mandala-bottom-left"><MandalaSVG /></div>
      <div className="bg-mandala bg-mandala-bottom-right"><MandalaSVG /></div>
    </div>
  );
};

export default MandalaBackground;
