<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="registerPage" value="${true}" />
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#000000">
    <meta name="description" content="Rejoignez TéléExpertise : un espace commun pour les infirmiers, médecins généralistes et spécialistes.">
    <title>Inscription — TéléExpertise</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <script src="${pageContext.request.contextPath}/assets/js/auth.js" defer></script>
</head>
<body class="register-page">
    <a class="skip-link" href="#auth-form">Aller au formulaire d'inscription</a>
    <%@ include file="fragments/auth-icons.jspf" %>
    <div class="page-shell">
        <%@ include file="fragments/auth-header.jspf" %>
        <main>
            <div class="page-heading"><p class="eyebrow">Rejoignez le collectif</p><span class="page-index">INSCRIPTION / 02</span></div>
            <div class="auth-layout">
                <%@ include file="fragments/auth-bento.jspf" %>
                <section class="auth-card" aria-labelledby="auth-title">
                    <nav class="auth-tabs" aria-label="Authentification">
                        <a class="auth-tab" href="${pageContext.request.contextPath}/login">Connexion</a>
                        <a class="auth-tab" href="${pageContext.request.contextPath}/register" aria-current="page">Inscription</a>
                    </nav>
                    <div class="form-intro">
                        <p class="form-eyebrow"><svg class="icon" aria-hidden="true"><use href="#icon-cross"/></svg> Chaque expertise compte</p>
                        <h1 class="form-title" id="auth-title">Faisons équipe.</h1>
                        <p class="form-description">Créez votre compte et prenons soin, ensemble.</p>
                    </div>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert" role="alert" tabindex="-1" data-auth-feedback>
                            <svg class="icon" aria-hidden="true"><use href="#icon-info"/></svg>
                            <p><strong>Inscription impossible</strong><c:out value="${errorMessage}" /></p>
                        </div>
                    </c:if>
                    <form class="auth-form" id="auth-form" action="${pageContext.request.contextPath}/register" method="post" accept-charset="UTF-8" data-auth-form>
                        <fieldset class="role-fieldset">
                            <legend class="role-legend">Vous exercez en tant que</legend>
                            <div class="role-options">
                                <label class="role-option">
                                    <input class="role-input" type="radio" name="role" value="INFIRMIER" ${empty param.role or param.role eq 'INFIRMIER' ? 'checked' : ''} required>
                                    <span class="role-content"><svg class="icon" aria-hidden="true"><use href="#icon-pulse"/></svg>Infirmier</span>
                                </label>
                                <label class="role-option">
                                    <input class="role-input" type="radio" name="role" value="GENERALISTE" ${param.role eq 'GENERALISTE' ? 'checked' : ''} required>
                                    <span class="role-content"><svg class="icon" aria-hidden="true"><use href="#icon-stethoscope"/></svg>Généraliste</span>
                                </label>
                                <label class="role-option">
                                    <input class="role-input" type="radio" name="role" value="SPECIALISTE" ${param.role eq 'SPECIALISTE' ? 'checked' : ''} required>
                                    <span class="role-content"><svg class="icon" aria-hidden="true"><use href="#icon-cross"/></svg>Spécialiste</span>
                                </label>
                            </div>
                        </fieldset>
                        <div class="field-row">
                            <div class="field">
                                <label class="field-label" for="prenom">Prénom</label>
                                <input class="field-input" type="text" id="prenom" name="prenom" placeholder="Votre prénom" value="${fn:escapeXml(param.prenom)}" autocomplete="given-name" maxlength="100" required>
                            </div>
                            <div class="field">
                                <label class="field-label" for="nom">Nom</label>
                                <input class="field-input" type="text" id="nom" name="nom" placeholder="Votre nom" value="${fn:escapeXml(param.nom)}" autocomplete="family-name" maxlength="100" required>
                            </div>
                        </div>
                        <div class="field">
                            <label class="field-label" for="email">Adresse e-mail professionnelle</label>
                            <div class="input-wrap">
                                <svg class="icon" aria-hidden="true"><use href="#icon-mail"/></svg>
                                <input class="field-input" type="email" id="email" name="email" placeholder="vous@etablissement.ma" value="${fn:escapeXml(param.email)}" autocomplete="username" maxlength="150" spellcheck="false" autocapitalize="none" required>
                            </div>
                        </div>
                        <div class="field">
                            <label class="field-label" for="password">Mot de passe</label>
                            <div class="input-wrap">
                                <svg class="icon" aria-hidden="true"><use href="#icon-lock"/></svg>
                                <input class="field-input" type="password" id="password" name="password" placeholder="Choisissez un mot de passe" autocomplete="new-password" aria-describedby="password-hint" required>
                                <button class="password-toggle" type="button" aria-label="Afficher le mot de passe" aria-controls="password" aria-pressed="false" data-password-toggle hidden>
                                    <svg class="icon" aria-hidden="true"><use href="#icon-eye"/><path class="eye-slash" d="m3 3 18 18"/></svg>
                                </button>
                            </div>
                            <p class="field-hint" id="password-hint">Utilisez un mot de passe unique à cet espace.</p>
                        </div>
                        <fieldset class="specialist-fields" data-specialist-fields>
                            <legend>Informations du spécialiste · facultatif</legend>
                            <div class="field-row">
                                <div class="field">
                                    <label class="field-label" for="specialite">Spécialité</label>
                                    <input class="field-input" type="text" id="specialite" name="specialite" placeholder="Ex. : Cardiologie" value="${fn:escapeXml(param.specialite)}" maxlength="255">
                                </div>
                                <div class="field">
                                    <label class="field-label" for="tarif">Tarif de consultation</label>
                                    <input class="field-input" type="number" id="tarif" name="tarif" placeholder="0,00" value="${fn:escapeXml(param.tarif)}" min="0" max="99999999.99" step="0.01" inputmode="decimal">
                                </div>
                            </div>
                        </fieldset>
                        <button class="submit-button" type="submit" data-loading-label="Création du compte…"><span data-submit-label>Créer mon compte</span><svg class="icon" aria-hidden="true"><use href="#icon-arrow"/></svg></button>
                    </form>
                    <p class="form-switch">Déjà dans le collectif ? <a href="${pageContext.request.contextPath}/login">Se connecter</a></p>
                    <p class="form-footnote"><svg class="icon" aria-hidden="true"><use href="#icon-shield"/></svg> Un espace réservé aux professionnels de santé.</p>
                </section>
            </div>
        </main>
        <%@ include file="fragments/auth-footer.jspf" %>
    </div>
</body>
</html>
