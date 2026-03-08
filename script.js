document.addEventListener('DOMContentLoaded', () => {

    const form = document.getElementById('flightSearchForm');
    const swapBtn = document.getElementById('swapBtn');
    const fromInput = document.getElementById('from');
    const toInput = document.getElementById('to');
    const loadingIndicator = document.getElementById('loadingIndicator');
    const resultsSection = document.getElementById('resultsSection');
    const resultsList = document.getElementById('flightResultsList');
    const template = document.getElementById('flightCardTemplate');

    // UI Interaction: Swap Origin & Destination
    swapBtn.addEventListener('click', () => {
        // Add subtle rotation animation to button
        swapBtn.style.transform = 'rotate(180deg)';
        setTimeout(() => swapBtn.style.transform = '', 300);

        const temp = fromInput.value;
        fromInput.value = toInput.value;
        toInput.value = temp;
    });

    // Handle Form Submission (Mocking backend interaction)
    form.addEventListener('submit', async (e) => {
        e.preventDefault(); // Prevent page reload

        const from = fromInput.value.trim() || 'JFK';
        const to = toInput.value.trim() || 'LHR';

        // Hide previous results and show loader
        resultsSection.classList.add('hidden');
        resultsList.innerHTML = '';
        loadingIndicator.classList.remove('hidden');

        try {
            // Fetch real data from backend API
            const response = await fetch(`/api/flights?origin=${from}&destination=${to}`);
            const flights = await response.json();

            loadingIndicator.classList.add('hidden');
            renderFlights(from, to, flights);
            resultsSection.classList.remove('hidden');

            // Smooth scroll to results
            resultsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
        } catch (error) {
            loadingIndicator.classList.add('hidden');
            console.error('Error fetching flights:', error);
            alert("Failed to load flights.");
        }
    });

    // Function to generate and render Flight Data from API
    function renderFlights(from, to, flights) {
        // Update the results count display
        document.querySelector('.results-count').textContent = `Showing ${flights.length} results`;

        flights.forEach((flight, index) => {
            // Clone template architecture
            const clone = template.content.cloneNode(true);
            const card = clone.querySelector('.flight-card');

            // Apply staggered animation delay
            card.style.animationDelay = `${index * 0.15}s`;

            // Populate data
            clone.querySelector('.airline-logo').textContent = flight.airline;
            clone.querySelector('.airline-name').textContent = flight.airline_name;

            clone.querySelector('.dep-time').textContent = flight.departure_time;
            clone.querySelector('.dep-city').textContent = flight.origin;

            clone.querySelector('.arr-time').textContent = flight.arrival_time;
            clone.querySelector('.arr-city').textContent = flight.destination;

            clone.querySelector('.duration-text').textContent = flight.duration;
            clone.querySelector('.price-val').textContent = `$${flight.price}`;

            // Add interactivity to the Book Button
            const bookBtn = clone.querySelector('.btn-book');
            bookBtn.addEventListener('click', async function () {
                this.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Processing';
                this.style.opacity = '0.8';

                // Get user from local storage
                const storedUserStr = localStorage.getItem('currentUser');
                let userId = null;
                if (storedUserStr) {
                    try {
                        const parsedUser = JSON.parse(storedUserStr);
                        userId = parsedUser.id;
                    } catch (e) {
                        console.error("Failed to parse user session");
                    }
                }

                if (!userId) {
                    // Force user to login
                    alert("Please log in to book a flight.");
                    window.location.href = '/login.html';
                    return;
                }

                try {
                    const res = await fetch('/api/book', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            user_id: userId,
                            flight_id: flight.id
                        })
                    });

                    if (res.ok) {
                        this.innerHTML = '<i class="fa-solid fa-check"></i> Booked!';
                        this.style.background = '#10b981';
                        this.style.opacity = '1';
                    } else {
                        throw new Error("Booking failed");
                    }
                } catch (err) {
                    this.innerHTML = 'Error!';
                    this.style.background = '#ef4444';
                    this.style.opacity = '1';
                }
            });

            resultsList.appendChild(clone);
        });
    }

    // Initialize date inputs with today and tomorrow
    const today = new Date();
    const tmrw = new Date();
    tmrw.setDate(today.getDate() + 5);

    document.getElementById('depart').valueAsDate = today;
    document.getElementById('return').valueAsDate = tmrw;

    // Login logic -> Check LocalStorage for Session On Load
    const unauthActions = document.getElementById('unauth-actions');
    const authActions = document.getElementById('auth-actions');
    const userNameDisplay = document.getElementById('userNameDisplay');
    const logoutBtn = document.getElementById('logoutBtn');

    // Check if user is logged in
    const storedUser = localStorage.getItem('currentUser');
    if (storedUser) {
        try {
            const user = JSON.parse(storedUser);
            userNameDisplay.textContent = user.name;
            unauthActions.classList.add('hidden');
            authActions.classList.remove('hidden');
        } catch (e) {
            console.error("Corrupted local storage data", e);
            localStorage.removeItem('currentUser');
        }

    }

    if (logoutBtn) {
        logoutBtn.addEventListener('click', () => {
            localStorage.removeItem('currentUser');
            unauthActions.classList.remove('hidden');
            authActions.classList.add('hidden');
            window.location.reload(); // Refresh the page to reflect logout state clearly
        });
    }
});
