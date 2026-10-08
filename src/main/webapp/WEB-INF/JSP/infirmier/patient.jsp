<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#000000">
    <meta name="description" content="Recherche et enregistrement patient — espace infirmier.">
    <title>Accueil patient — TéléExpertise</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/infirmier.css">
</head>
<body class="infirmier-page">
    <a class="skip-link" href="#contenu">Aller au contenu</a>
    <%@ include file="../fragments/auth-icons.jspf" %>
    <div class="page-shell">
        <%@ include file="../fragments/infirmier-navbar.jspf" %>
        <main id="contenu">
            <div class="page-heading">
                <p class="eyebrow">Espace infirmier</p>
                <span class="page-index">PATIENT / RECHERCHE</span>
            </div>

            <div class="infirmier-intro">
                <h1>Accueil <em>patient.</em></h1>
                <p>Recherchez un dossier par numéro de sécurité sociale. S&rsquo;il existe, saisissez les signes vitaux. Sinon, créez le dossier.</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert" role="alert">
                    <svg class="icon" aria-hidden="true"><use href="#icon-info"/></svg>
                    <p><c:out value="${errorMessage}" /></p>
                </div>
            </c:if>

            <section class="panel" aria-labelledby="titre-recherche" style="margin-bottom: 20px;">
                <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-person"/></svg> Recherche du dossier</p>
                <h2 id="titre-recherche">Rechercher un patient</h2>
                <p>La recherche se fait par numéro de sécurité sociale.</p>
                <form class="search-form" method="get" action="${pageContext.request.contextPath}/infirmier/patient" accept-charset="UTF-8">
                    <div class="field">
                        <label class="field-label" for="numero">Numéro de sécurité sociale</label>
                        <div class="input-wrap">
                            <svg class="icon" aria-hidden="true"><use href="#icon-person"/></svg>
                            <input class="field-input" type="text" id="numero" name="numero" placeholder="Ex. 1234567890123" value="${fn:escapeXml(param.numero)}" maxlength="100" required>
                        </div>
                    </div>
                    <button class="submit-button" type="submit"><span>Rechercher</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                </form>
            </section>

            <c:if test="${not empty patient}">
                <section class="panel" aria-labelledby="titre-existant" style="margin-bottom: 20px;">
                    <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg> Dossier retrouvé</p>
                    <h2 id="titre-existant">Patient trouvé</h2>
                    <p>Ajoutez les signes vitaux du jour. Le patient rejoindra la file d&rsquo;attente.</p>
                    <div class="found-banner">
                        <svg class="icon" aria-hidden="true"><use href="#icon-check"/></svg>
                        <span><strong><c:out value="${patient.prenom}" /> <c:out value="${patient.nom}" /></strong> — N° <c:out value="${patient.numeroSecuriteSociale}" /></span>
                    </div>
                    <div class="patient-recap">
                        <div><span>Nom</span><strong><c:out value="${patient.nom}" /></strong></div>
                        <div><span>Prénom</span><strong><c:out value="${patient.prenom}" /></strong></div>
                        <div><span>N° sécurité sociale</span><strong><c:out value="${patient.numeroSecuriteSociale}" /></strong></div>
                    </div>
                    <form class="auth-form" method="post" action="${pageContext.request.contextPath}/infirmier/patient" accept-charset="UTF-8">
                        <input type="hidden" name="action" value="existant">
                        <input type="hidden" name="numeroSecuriteSociale" value="${fn:escapeXml(patient.numeroSecuriteSociale)}">
                        <div class="form-grid-3">
                            <div class="field">
                                <label class="field-label" for="ex-tension">Tension artérielle</label>
                                <input class="field-input" type="text" id="ex-tension" name="tensionArterielle" placeholder="Ex. 12/8" maxlength="20" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="ex-fc">Fréquence cardiaque (bpm)</label>
                                <input class="field-input" type="number" id="ex-fc" name="frequenceCardiaque" min="0" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="ex-temp">Température (°C)</label>
                                <input class="field-input" type="number" id="ex-temp" name="temperature" step="0.1" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="ex-fr">Fréquence respiratoire</label>
                                <input class="field-input" type="number" id="ex-fr" name="frequenceRespiratoire" min="0" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="ex-poids">Poids (kg)</label>
                                <input class="field-input" type="number" id="ex-poids" name="poids" step="0.01" min="0" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="ex-taille">Taille (cm)</label>
                                <input class="field-input" type="number" id="ex-taille" name="taille" step="0.01" min="0" required>
                            </div>
                            <div class="form-actions">
                                <button class="submit-button" type="submit"><span>Ajouter à la file d&rsquo;attente</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                            </div>
                        </div>
                    </form>
                </section>
            </c:if>

            <c:if test="${patientNonTrouve}">
                <section class="panel" aria-labelledby="titre-nouveau">
                    <p class="panel-kicker"><svg class="icon" aria-hidden="true"><use href="#icon-info"/></svg> Nouveau dossier</p>
                    <h2 id="titre-nouveau">Créer le dossier patient</h2>
                    <p>Aucun dossier trouvé pour le N° <strong><c:out value="${numeroRecherche}" /></strong>. Complétez les informations ci-dessous.</p>
                    <form class="auth-form" method="post" action="${pageContext.request.contextPath}/infirmier/patient" accept-charset="UTF-8">
                        <input type="hidden" name="action" value="nouveau">
                        <div class="form-grid">
                            <p class="form-section-title">Informations personnelles</p>
                            <div class="field">
                                <label class="field-label" for="nom">Nom</label>
                                <input class="field-input" type="text" id="nom" name="nom" maxlength="100" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="prenom">Prénom</label>
                                <input class="field-input" type="text" id="prenom" name="prenom" maxlength="100" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="dateNaissance">Date de naissance</label>
                                <input class="field-input" type="date" id="dateNaissance" name="dateNaissance" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="numeroSecuriteSociale">N° sécurité sociale</label>
                                <input class="field-input" type="text" id="numeroSecuriteSociale" name="numeroSecuriteSociale" value="${fn:escapeXml(numeroRecherche)}" maxlength="100" required readonly>
                            </div>
                            <div class="field">
                                <label class="field-label" for="telephone">Téléphone</label>
                                <input class="field-input" type="tel" id="telephone" name="telephone" maxlength="30">
                            </div>
                            <div class="field">
                                <label class="field-label" for="mutuelle">Mutuelle</label>
                                <input class="field-input" type="text" id="mutuelle" name="mutuelle" maxlength="100">
                            </div>
                            <div class="field field-full">
                                <label class="field-label" for="adresse">Adresse</label>
                                <input class="field-input" type="text" id="adresse" name="adresse">
                            </div>
                            <div class="field field-full">
                                <label class="field-label" for="antecedents">Antécédents</label>
                                <textarea class="field-input" id="antecedents" name="antecedents"></textarea>
                            </div>
                            <div class="field">
                                <label class="field-label" for="allergies">Allergies</label>
                                <textarea class="field-input" id="allergies" name="allergies"></textarea>
                            </div>
                            <div class="field">
                                <label class="field-label" for="traitements">Traitements en cours</label>
                                <textarea class="field-input" id="traitements" name="traitementsEnCours"></textarea>
                            </div>

                            <p class="form-section-title">Signes vitaux du jour</p>
                            <div class="field">
                                <label class="field-label" for="tension">Tension artérielle</label>
                                <input class="field-input" type="text" id="tension" name="tensionArterielle" placeholder="Ex. 12/8" maxlength="20" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="fc">Fréquence cardiaque (bpm)</label>
                                <input class="field-input" type="number" id="fc" name="frequenceCardiaque" min="0" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="temp">Température (°C)</label>
                                <input class="field-input" type="number" id="temp" name="temperature" step="0.1" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="fr">Fréquence respiratoire</label>
                                <input class="field-input" type="number" id="fr" name="frequenceRespiratoire" min="0" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="poids">Poids (kg)</label>
                                <input class="field-input" type="number" id="poids" name="poids" step="0.01" min="0" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="taille">Taille (cm)</label>
                                <input class="field-input" type="number" id="taille" name="taille" step="0.01" min="0" required>
                            </div>
                            <div class="form-actions">
                                <button class="submit-button" type="submit"><span>Enregistrer et mettre en file</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                            </div>
                        </div>
                    </form>
                </section>
            </c:if>
        </main>
        <%@ include file="../fragments/auth-footer.jspf" %>
    </div>
</body>
</html>
