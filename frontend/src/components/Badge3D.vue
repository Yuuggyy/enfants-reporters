<template>
  <div class="relative flex flex-col items-center justify-center p-5 rounded-2xl bg-gradient-to-b from-white/[0.06] to-white/[0.02] border border-white/10 hover:border-[#00ADEF]/50 transition-all duration-300 group shadow-lg hover:shadow-[0_0_25px_rgba(0,173,239,0.25)]">
    
    <!-- Top Sparkle Icon / Level Tag -->
    <div class="w-full flex items-center justify-between text-[11px] mb-1">
      <span class="font-mono text-slate-400">UNICEF 3D</span>
      <span v-if="unlocked" class="px-2 py-0.5 rounded-full bg-[#00ADEF]/15 text-[#00ADEF] font-black tracking-wider text-[10px] border border-[#00ADEF]/30">
        DÉBLOQUÉ
      </span>
      <span v-else class="px-2 py-0.5 rounded-full bg-white/5 text-slate-400 font-bold text-[10px] border border-white/10">
        VERROUILLÉ
      </span>
    </div>

    <div ref="canvasContainer" class="w-44 h-44 flex items-center justify-center cursor-grab active:cursor-grabbing relative">
      <!-- Ambient Glow Behind 3D Badge -->
      <div 
        class="absolute inset-4 rounded-full blur-xl opacity-30 group-hover:opacity-60 transition-opacity pointer-events-none"
        :style="{ backgroundColor: unlocked ? color : '#334155' }"
      ></div>

      <!-- 2D Fallback if WebGL unavailable -->
      <div v-if="fallbackMode" class="w-28 h-28 rounded-2xl flex flex-col items-center justify-center text-white shadow-xl transform transition-transform group-hover:scale-105 border border-white/20" :style="{ backgroundColor: color }">
        <span class="text-3xl">🏅</span>
        <span class="text-[11px] font-bold mt-1 text-center px-2">{{ title }}</span>
      </div>
    </div>
    
    <div class="text-center mt-2 w-full">
      <div class="font-heading font-black text-slate-100 text-sm group-hover:text-[#00ADEF] transition-colors">{{ title }}</div>
      <div class="text-[11px] text-slate-400 mt-0.5">{{ subtitle }}</div>
      
      <div v-if="unlocked" class="mt-2.5 inline-flex items-center gap-1.5 text-[11px] font-bold px-3 py-1 rounded-xl bg-[#00ADEF]/15 text-[#00ADEF] border border-[#00ADEF]/30">
        <span class="w-1.5 h-1.5 rounded-full bg-[#00ADEF] animate-ping"></span>
        Acquis • Prêt à partager
      </div>
      <div v-else class="mt-2.5 inline-flex items-center gap-1.5 text-[11px] font-medium px-3 py-1 rounded-xl bg-white/5 text-slate-400 border border-white/5">
        <span>🔒 Compléter le module</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
import * as THREE from 'three'

const props = defineProps({
  title: { type: String, default: 'Badge d\'Honneur' },
  subtitle: { type: String, default: 'UNICEF RDC' },
  color: { type: String, default: '#00ADEF' },
  unlocked: { type: Boolean, default: false }
})

const canvasContainer = ref(null)
const fallbackMode = ref(false)

let scene, camera, renderer, badgeMesh, ringMesh, gemMesh, animationFrameId

function initThree() {
  if (!canvasContainer.value) return

  try {
    const width = 176
    const height = 176

    scene = new THREE.Scene()
    camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 1000)
    camera.position.z = 4.8

    renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true })
    renderer.setSize(width, height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

    canvasContainer.value.appendChild(renderer.domElement)

    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 1.2)
    scene.add(ambientLight)

    const keyLight = new THREE.DirectionalLight(0xffffff, 2.5)
    keyLight.position.set(4, 5, 5)
    scene.add(keyLight)

    const accentLight = new THREE.PointLight(props.color, 3.5, 10)
    accentLight.position.set(-3, -2, 3)
    scene.add(accentLight)

    const topBlueLight = new THREE.PointLight(0x00ADEF, 2.5, 8)
    topBlueLight.position.set(0, 4, 2)
    scene.add(topBlueLight)

    // Main Badge Coin Geometry
    const geometry = new THREE.CylinderGeometry(1.4, 1.4, 0.22, 48)
    const material = new THREE.MeshStandardMaterial({
      color: props.unlocked ? new THREE.Color(props.color) : new THREE.Color(0x334155),
      metalness: 0.9,
      roughness: 0.15,
      wireframe: !props.unlocked
    })

    badgeMesh = new THREE.Mesh(geometry, material)
    badgeMesh.rotation.x = Math.PI / 2
    scene.add(badgeMesh)

    // Outer Glowing Ring
    const ringGeo = new THREE.TorusGeometry(1.2, 0.08, 16, 64)
    const ringMat = new THREE.MeshStandardMaterial({
      color: props.unlocked ? 0x00ADEF : 0x64748b,
      metalness: 0.95,
      roughness: 0.1
    })
    ringMesh = new THREE.Mesh(ringGeo, ringMat)
    badgeMesh.add(ringMesh)

    // Center Gem / Emblem Octahedron
    const gemGeo = new THREE.OctahedronGeometry(0.55, 0)
    const gemMat = new THREE.MeshStandardMaterial({
      color: props.unlocked ? 0xffffff : 0x475569,
      metalness: 0.8,
      roughness: 0.1,
      emissive: props.unlocked ? new THREE.Color(props.color) : new THREE.Color(0x000000),
      emissiveIntensity: props.unlocked ? 0.6 : 0
    })
    gemMesh = new THREE.Mesh(gemGeo, gemMat)
    gemMesh.position.z = 0.15
    badgeMesh.add(gemMesh)

    // Interactive Drag / Hover rotation
    let isDragging = false
    let previousMousePosition = { x: 0, y: 0 }

    const dom = renderer.domElement
    dom.addEventListener('mousedown', (e) => {
      isDragging = true
      previousMousePosition = { x: e.clientX, y: e.clientY }
    })

    window.addEventListener('mouseup', () => {
      isDragging = false
    })

    dom.addEventListener('mousemove', (e) => {
      if (isDragging && badgeMesh) {
        const deltaX = e.clientX - previousMousePosition.x
        const deltaY = e.clientY - previousMousePosition.y
        badgeMesh.rotation.y += deltaX * 0.02
        badgeMesh.rotation.x += deltaY * 0.02
        previousMousePosition = { x: e.clientX, y: e.clientY }
      }
    })

    // Animation Loop
    const animate = () => {
      animationFrameId = requestAnimationFrame(animate)
      if (badgeMesh && !isDragging) {
        badgeMesh.rotation.y += props.unlocked ? 0.012 : 0.004
        badgeMesh.rotation.z = Math.sin(Date.now() * 0.002) * 0.08
        if (gemMesh) {
          gemMesh.rotation.y += 0.02
        }
      }
      renderer.render(scene, camera)
    }
    animate()

  } catch (err) {
    console.warn('Three.js fallback', err)
    fallbackMode.value = true
  }
}

onMounted(() => {
  initThree()
})

onBeforeUnmount(() => {
  if (animationFrameId) cancelAnimationFrame(animationFrameId)
  if (renderer && renderer.domElement && renderer.domElement.parentNode) {
    renderer.domElement.parentNode.removeChild(renderer.domElement)
  }
})

watch(() => props.color, (newColor) => {
  if (badgeMesh && badgeMesh.material) {
    badgeMesh.material.color.set(newColor)
  }
})
</script>
