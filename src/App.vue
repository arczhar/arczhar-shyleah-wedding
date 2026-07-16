<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import { supabase, supabaseConfigured } from './supabase'

const invitationOpen = ref(false)
const menuOpen = ref(false)
const now = ref(new Date())
const sending = ref(false)
const submitted = ref(false)
const submitError = ref('')

const weddingDate = new Date('2026-07-25T14:00:00+08:00')
const rsvpDeadline = new Date('2026-07-20T23:59:59+08:00')
let timer

onMounted(() => {
  timer = window.setInterval(() => (now.value = new Date()), 1000)
})

onBeforeUnmount(() => window.clearInterval(timer))

const countdown = computed(() => {
  const diff = Math.max(0, weddingDate.getTime() - now.value.getTime())
  return {
    days: Math.floor(diff / 86400000),
    hours: Math.floor((diff / 3600000) % 24),
    minutes: Math.floor((diff / 60000) % 60),
    seconds: Math.floor((diff / 1000) % 60),
  }
})

const rsvpClosed = computed(() => now.value > rsvpDeadline)

const form = reactive({
  full_name: '',
  attendance: 'attending',
  message: '',
})

const principalSponsors = [
  ['Mr. Jessie Adolfo', 'Mrs. Jacqueline Adolfo'],
  ['Mr. Stanley Awid', 'Mrs. Imelda Awid'],
  ['Mr. Ronald Bautista', 'Mrs. Sharon Bautista'],
  ['Engr. Bernardo Buenaventura', 'Mrs. Claribel Buenaventura'],
  ['Mr. Ryan Camporedondo', 'Mrs. Caressa Marie Camporedondo'],
  ['PCPL Christian Paul Dueñas', 'Mrs. Diana Dueñas'],
  ['Mr. Francisco Elas, Jr.', 'Shirley Elas, EdD'],
  ['Engr. Arshamier Husin', 'Mrs. Hazel Joy Husin, RN'],
  ['Mr. Ronnie Ligalig', 'Mrs. Janice Ligalig'],
  ['Dr. Michael Joavanni Perez', 'Mrs. Ma. Lorraine Perez'],
  ['Dr. Revelino Sanchez', 'Mrs. Eva Sanchez'],
  ['Mr. Johnny Villaverde', 'Mrs. Myla Villaverde'],
  ['Mr. Ricardo Quintana', 'Mrs. Norma Quintana'],
  ['Medzfar Ameril, EdD', 'Shellame Mabalo, EdD'],
  ['Mr. James Ryan Amamangpang', 'Mrs. Erlinda Campos'],
  ['Mr. Josel Franc', 'Mrs. Bernadita Calma'],
]

const submitRsvp = async () => {
  submitError.value = ''

  if (!form.full_name.trim()) {
    submitError.value = 'Please enter your full name.'
    return
  }

  sending.value = true

  const payload = {
    full_name: form.full_name.trim(),
    attending: form.attendance === 'attending',
    message: form.message.trim() || null,
  }

  try {
    if (supabaseConfigured) {
      const { error } = await supabase
        .from('rsvps')
        .insert(payload)

      if (error) throw error
    } else {
      const saved = JSON.parse(
        localStorage.getItem('wedding-rsvps') || '[]'
      )

      saved.push({
        ...payload,
        created_at: new Date().toISOString(),
      })

      localStorage.setItem(
        'wedding-rsvps',
        JSON.stringify(saved)
      )
    }

    submitted.value = true
  } catch (error) {
    submitError.value =
      error?.message ||
      'We could not submit your RSVP. Please try again.'
  } finally {
    sending.value = false
  }
}
const scrollTo = (id) => {
  menuOpen.value = false
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
}
</script>

<template>
  <div class="site-shell">
    <!-- Opening Screen -->
    <div v-if="!invitationOpen" class="opening-screen">
      <div class="opening-glow"></div>
      <div class="corner corner-a"></div>
      <div class="corner corner-b"></div>

      <div class="opening-card">
        <p class="arabic">
          بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ
        </p>

        <p class="eyebrow">
          Together with their families
        </p>

        <h1>
          <span>Arczhar</span>
          <small>&</small>
          <span>Shyleah</span>
        </h1>

        <p class="opening-date">
          25 · 07 · 2026
        </p>

        <button
          class="gold-button"
          type="button"
          @click="invitationOpen = true"
        >
          Open Invitation
        </button>
      </div>
    </div>

    <!-- Main Invitation -->
    <template v-else>
      <!-- Navigation -->
      <header class="nav-wrap">
        <a
          class="brand"
          href="#hero"
          @click.prevent="scrollTo('hero')"
        >
          A <span>&</span> S
        </a>

        <button
          class="menu-button"
          type="button"
          aria-label="Open menu"
          @click="menuOpen = !menuOpen"
        >
          ☰
        </button>

        <nav :class="{ open: menuOpen }">
          <button
            type="button"
            @click="scrollTo('details')"
          >
            Details
          </button>

          <button
            type="button"
            @click="scrollTo('entourage')"
          >
            Entourage
          </button>

          <button
            type="button"
            @click="scrollTo('dress-code')"
          >
            Dress Code
          </button>

          <button
            type="button"
            @click="scrollTo('rsvp')"
          >
            RSVP
          </button>
        </nav>
      </header>

      <main>
        <!-- Hero Section -->
        <section
          id="hero"
          class="hero section-pad"
        >
          <div class="sparkles"></div>

          <div class="hero-frame">
            <p class="arabic hero-arabic">
              بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ
            </p>

            <p class="intro-copy">
              In the name of Allah, the Most Gracious, the Most
              Merciful. With the blessings and grace of Allah SWT,
              we are delighted to invite you to join us on our
              special day.
            </p>

            <h2 class="script-title">
              Arczhar <span>&</span> Shyleah
            </h2>

            <p class="honor-copy">
              It would be a great honor and joy for us if you could
              attend and bless us with your prayers.
            </p>

            <div class="date-lockup">
              <span>Saturday</span>
              <strong>25</strong>
              <span>
                July
                <br />
                2026
              </span>
            </div>

            <div class="hero-event-card">
  <div class="hero-event-detail">
    <span class="hero-event-label">Time</span>
    <strong>2:00 PM</strong>
  </div>

  <div class="hero-event-divider"></div>

  <div class="hero-event-detail hero-event-venue">
    <span class="hero-event-label">Venue</span>
    <strong>Convention Hall A</strong>
    <small>LM Metro Hotel</small>
  </div>
</div>
            <button
              class="gold-button"
              type="button"
              @click="scrollTo('rsvp')"
            >
              Confirm Attendance
            </button>
          </div>
        </section>

        <!-- Countdown Section -->
        <section class="countdown section-pad">
          <p class="eyebrow">
            Counting down to our day
          </p>

          <h2 class="section-title">
            In Shaa Allah
          </h2>

          <div class="countdown-grid">
            <div
              v-for="(value, label) in countdown"
              :key="label"
              class="count-card"
            >
              <strong>
                {{ String(value).padStart(2, '0') }}
              </strong>

              <span>
                {{ label }}
              </span>
            </div>
          </div>
        </section>

        <!-- Wedding Details -->
        <section
          id="details"
          class="details section-pad pattern-section"
        >
          <p class="eyebrow">
            The celebration
          </p>

          <h2 class="section-title">
            Wedding Details
          </h2>

          <div class="detail-grid">
            <article class="glass-card">
              <span class="icon">◈</span>

              <h3>Date & Time</h3>

              <p>Saturday, July 25, 2026</p>
              <p>2:00 in the afternoon</p>
            </article>

            <article class="glass-card">
              <span class="icon">⌖</span>

              <h3>Venue</h3>

              <p>Convention Hall, LM Metro Hotel</p>

              <p>
                Don Toribio Street, Tetuan, Zamboanga City
              </p>
            </article>
          </div>

          <div class="button-row">
            <a
              class="gold-button"
              href="https://maps.app.goo.gl/TngeDTPqfshYAqmH8"
              target="_blank"
              rel="noopener"
            >
              Open Google Maps
            </a>

            <a
              class="outline-button"
              href="https://calendar.google.com/calendar/render?action=TEMPLATE&text=Arczhar+%26+Shyleah+Wedding&dates=20260725T060000Z/20260725T100000Z&details=Wedding+celebration+of+Arczhar+and+Shyleah&location=LM+Metro+Hotel%2C+Don+Toribio+Street%2C+Tetuan%2C+Zamboanga+City"
              target="_blank"
              rel="noopener"
            >
              Add to Calendar
            </a>
          </div>
        </section>

        <!-- Entourage -->
        <section
          id="entourage"
          class="entourage section-pad"
        >
          <p class="eyebrow">
            Mummuh · Punzalan
          </p>

          <h2 class="section-title">
            The Wedding Party
          </h2>

          <div class="parents-grid">
            <article>
              <h3>Parents of the Groom</h3>
              <p>Mr. Radzmil Madjan Mummuh</p>
              <p>Mrs. Razhierda Alvarez Mummuh, PhD</p>
            </article>

            <article>
              <h3>Parents of the Bride</h3>
              <p>Mr. Rico Leonardo Punzalan</p>
              <p>Mrs. Merylen Ponce Punzalan</p>
            </article>
          </div>

          <div class="imam-wrap">
          <article class="glass-card imam-card">
            <h3>Officiating Imam</h3>
            <p>Imam Sahibuddin I. Muktadir</p>
            <p>Shiekh Ali Imran Al-Raschid Arsad</p>
          </article>
        </div>

          <details class="entourage-group">
            <summary>
              Principal Sponsors
              <span>16 pairs</span>
            </summary>

            <div class="sponsor-list">
              <div
                v-for="pair in principalSponsors"
                :key="pair[0]"
                class="sponsor-row"
              >
                <span>{{ pair[0] }}</span>
                <span>{{ pair[1] }}</span>
              </div>
            </div>
          </details>

          <div class="party-grid">
            <article class="glass-card">
              <h3>Best Man</h3>

              <p>Aicramier A. Mummuh</p>

              <h3 class="subhead">
                Groomsmen
              </h3>

              <p>Al-Basri Nasim</p>
              <p>Naikar Hashim</p>
              <p>Jayremy Alvarez</p>
              <p>Ar-Rhadzhier Mummuh</p>
            </article>

            <article class="glass-card">
              <h3>Maid of Honor</h3>

              <p>Airica Jhen P. Punzalan</p>

              <h3 class="subhead">
                Bridesmaids
              </h3>

              <p>Lea Rose Ramillano</p>
              <p>Thrixy Shairra Keint Mummuh</p>
              <p>Kian Callana Kairan</p>
              <p>Jessa Natividad</p>
            </article>
          </div>

          <div class="little-ones">
            <h3 class="script-subtitle">
              Little Ones
            </h3>

            <div class="three-col">
              <div>
                <strong>Qur'an Bearer</strong>
                <span>Hazza Zair Husin</span>
              </div>

              <div>
                <strong>Ring Bearer</strong>
                <span>Fheby Xyron Ford Punzalan</span>
              </div>

              <div>
                <strong>Flower Girls</strong>

                <span>
                  Zafiyah Aeza Husin
                  <br />
                  Vanessa Punzalan
                </span>
              </div>
            </div>
          </div>

          <div class="witnesses">
            <h3>Witnesses</h3>

            <p>
              Mr. Al-Ahmar B. Mahiluddin, RN
            </p>

            <p>
              Mr. Sharif Nedzmar B. Nooh, R.Ph.
            </p>
          </div>
        </section>

        <!-- Dress Code -->
        <section
          id="dress-code"
          class="dress-code section-pad pattern-section"
        >
          <p class="eyebrow">
            The details
          </p>

          <h2 class="section-title">
            Dress Code
          </h2>

          <p class="center-copy">
            We would love to see you in your best and most
            comfortable formal or semi-formal attire that suits
            our motif.
          </p>

          <div class="palette">
            <div>
              <span class="swatch burgundy"></span>
              <strong>Burgundy</strong>
            </div>

            <div>
              <span class="swatch gold"></span>
              <strong>Gold</strong>
            </div>

            <div>
              <span class="swatch rose-gold"></span>
              <strong>Rose Gold</strong>
            </div>
          </div>

          <div class="dress-note">
          <h3>Modesty & Color Reminder</h3>

          <p>
            In respect of Muslim traditions, guests are kindly requested
            to wear modest and appropriate attire. Please avoid revealing
            or overly tight-fitting clothing.
          </p>

          <p>
            Please refrain from wearing full white or cream, as these
            colors are reserved for the bride and groom.
          </p>
        </div>

          <div class="reminders">
            <div>
              <span>◷</span>
              <strong>Be on time</strong>
            </div>

            <div>
              <span>♡</span>
              <strong>Finish the event</strong>
            </div>

            <div>
              <span>✦</span>
              <strong>Enjoy & have fun</strong>
            </div>
          </div>
        </section>

        <!-- RSVP Section -->
        <section
          id="rsvp"
          class="rsvp section-pad"
        >
          <p class="eyebrow">
            Kindly respond
          </p>

          <h2 class="section-title">
            RSVP
          </h2>

          <!-- Successful Submission -->
          <div
            v-if="submitted"
            class="success-card"
          >
            <span>✓</span>

            <h3>
              Response received
            </h3>

            <p>
              Thank you! We look forward to celebrating with you,
              In Shaa Allah.
            </p>
          </div>

          <!-- RSVP Closed -->
          <div
            v-else-if="rsvpClosed"
            class="closed-card"
          >
            <h3>
              RSVP is now closed
            </h3>

            <p>
              For urgent concerns, please contact us at
              <a href="tel:+639943761014">
                0994 376 1014
              </a>.
            </p>
          </div>

          <!-- RSVP Form -->
          <form
            v-else
            class="rsvp-form"
            @submit.prevent="submitRsvp"
          >
            <label>
              Full name

              <input
                v-model="form.full_name"
                type="text"
                autocomplete="name"
                placeholder="Enter your full name"
                required
              />
            </label>

            <fieldset>
              <legend>
                Will you attend?
              </legend>

              <label class="radio">
                <input
                  v-model="form.attendance"
                  type="radio"
                  value="attending"
                />

                Yes, I will attend
              </label>

              <label class="radio">
                <input
                  v-model="form.attendance"
                  type="radio"
                  value="declined"
                />

                Unable to attend
              </label>
            </fieldset>

            <label>
              Message for the couple
              <span>(optional)</span>

              <textarea
                v-model="form.message"
                rows="4"
                placeholder="Leave a short message"
              ></textarea>
            </label>

            <p
              v-if="submitError"
              class="form-error"
            >
              {{ submitError }}
            </p>

            <button
              class="gold-button full"
              type="submit"
              :disabled="sending"
            >
              {{ sending ? 'Submitting…' : 'Submit RSVP' }}
            </button>

            <p
              v-if="!supabaseConfigured"
              class="demo-note"
            >
              Demo mode: responses are currently saved only in
              this browser. Connect Supabase before public
              deployment.
            </p>
          </form>
        </section>
      </main>

      <!-- Footer -->
      <footer>
        <p class="script-subtitle">
          Arczhar & Shyleah
        </p>

        <p>
          25 July 2026
        </p>

        <p class="blessing">
          May Allah bless this union with love, peace, and
          endless barakah.
        </p>
      </footer>
    </template>
  </div>
</template>