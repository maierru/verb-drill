// Shared verb page logic
// Expects VERB_CONFIG: { originKey, labels, verbForms, phrases }

function renderPhrases(filteredPhrases = VERB_CONFIG.phrases) {
    const container = document.getElementById('phraseList');
    const { originKey, labels } = VERB_CONFIG;
    container.innerHTML = '';

    filteredPhrases.forEach((phrase, index) => {
        const card = document.createElement('div');
        card.className = 'phrase-card';
        card.innerHTML = `
            <div class="phrase-header" onclick="toggleCard(this.parentElement)">
                <span class="phrase-number">${index + 1}</span>
                <span class="origin-text">${phrase[originKey]}</span>
                <span class="toggle-icon">▼</span>
            </div>
            <div class="portuguese-text">
                <div class="pt-content">
                    <div class="pt-label">${labels.target}</div>
                    <div class="pt-phrase">${highlightVerb(phrase.pt)}</div>
                    <span class="tense-tag">${phrase.tense}</span>
                </div>
            </div>
        `;
        container.appendChild(card);
    });

    document.getElementById('stats').textContent =
        `${labels.showing}: ${filteredPhrases.length} ${labels.of} ${VERB_CONFIG.phrases.length} ${labels.phrases}`;
}

function highlightVerb(text) {
    if (!VERB_CONFIG.verbForms || VERB_CONFIG.verbForms.length === 0) return text;

    let result = text;
    VERB_CONFIG.verbForms.forEach(form => {
        const regex = new RegExp(`\\b(${form})\\b`, 'gi');
        result = result.replace(regex, '<span class="verb-highlight">$1</span>');
    });
    return result;
}

function toggleCard(card) {
    card.classList.toggle('open');
}

function showAll() {
    document.querySelectorAll('.phrase-card').forEach(card => {
        card.classList.add('open');
    });
}

function hideAll() {
    document.querySelectorAll('.phrase-card').forEach(card => {
        card.classList.remove('open');
    });
}

// Initialize
document.getElementById('searchInput').addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase();
    const { originKey, phrases } = VERB_CONFIG;
    const filtered = phrases.filter(p =>
        p[originKey].toLowerCase().includes(query) ||
        p.pt.toLowerCase().includes(query) ||
        p.tense.toLowerCase().includes(query)
    );
    renderPhrases(filtered);
});

renderPhrases();
